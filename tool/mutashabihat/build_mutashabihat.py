"""Builds assets/quran/mutashabihat.json from QUL's "Mutashabihat ul Quran" download.

Usage: python3 -I tool/mutashabihat/build_mutashabihat.py <qul zip> <hafs json> <output json>

The QUL word positions skip the ۞ and ۩ marks that our mushaf text keeps as separate tokens,
and a few positions are off by one to three words. This script maps every position onto the
whitespace-split words of our text and moves an off position onto the exact phrase when it sits
within three words; positions past the end of the ayah are dropped. When the source range of a
phrase runs past its ayah, the range listed for that same ayah is used instead.
"""
import json
import re
import sys
import zipfile

MARKS = {'۞', '۩'}


def normalize(word):
    word = re.sub(r'[^ء-غف-يٱ]', '', word)
    for a, b in (('ٱ', 'ا'), ('أ', 'ا'), ('إ', 'ا'), ('آ', 'ا'), ('ى', 'ي'), ('ة', 'ه')):
        word = word.replace(a, b)
    return word


def ayah_key_order(key):
    surah, ayah = key.split(':')
    return int(surah), int(ayah)


def main(zip_path, hafs_path, out_path):
    with zipfile.ZipFile(zip_path) as archive:
        phrases = json.loads(archive.read('phrases.json'))
    hafs = json.load(open(hafs_path, encoding='utf-8'))

    def raw_words(key):
        surah, ayah = ayah_key_order(key)
        return hafs[str(surah)][ayah - 1]['text'].split()

    def word_map(key):
        raw = raw_words(key)
        positions = [i for i, w in enumerate(raw) if w not in MARKS]
        return raw, positions, [normalize(raw[i]) for i in positions]

    out, stats = [], {'kept': 0, 'moved': 0, 'dropped': 0}
    for pid in sorted(phrases, key=int):
        phrase = phrases[pid]
        source = phrase['source']
        src_raw, src_pos, src_norm = word_map(source['key'])
        start, end = source['from'] - 1, source['to']
        own = phrase['ayah'].get(source['key'])
        if end > len(src_pos) and own:
            start, end = own[0][0] - 1, own[0][1]
        if end > len(src_pos):
            stats['dropped'] += len(phrase['ayah'])
            continue
        reference = src_norm[start:end]
        length = len(reference)
        text = ' '.join(src_raw[src_pos[i]] for i in range(start, end))
        ayahs = {}
        for key in sorted(phrase['ayah'], key=ayah_key_order):
            _, positions, norm = word_map(key)
            ranges = []
            for first, last in sorted({tuple(r) for r in phrase['ayah'][key]}):
                begin = first - 1
                if norm[begin:begin + length] != reference:
                    for delta in (-1, 1, -2, 2, -3, 3):
                        candidate = begin + delta
                        if 0 <= candidate and norm[candidate:candidate + length] == reference:
                            begin, last = candidate, candidate + length
                            stats['moved'] += 1
                            break
                if last > len(positions) or begin < 0:
                    stats['dropped'] += 1
                    continue
                stats['kept'] += 1
                ranges.append([positions[begin] + 1, positions[last - 1] + 1])
            if ranges:
                ayahs[key] = sorted({tuple(r) for r in ranges})
        if len(ayahs) > 1:
            out.append({'id': int(pid), 'text': text, 'source': source['key'], 'ayahs': ayahs})

    with open(out_path, 'w', encoding='utf-8') as f:
        json.dump({'phrases': out}, f, ensure_ascii=False, separators=(',', ':'))
    print(f"phrases: {len(out)}, occurrences kept: {stats['kept']}, moved: {stats['moved']}, dropped: {stats['dropped']}")


if __name__ == '__main__':
    main(*sys.argv[1:4])
