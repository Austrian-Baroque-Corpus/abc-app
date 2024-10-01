import glob
import os
import tqdm


SOURCE_DIR = 'data/editions'
FILES = '*.xml'
source_glob = glob.glob(os.path.join(SOURCE_DIR, FILES))

NS = [
    ' xmlns="http://www.tei-c.org/ns/1.0"'
]

NSMAP = {
    "tei": "http://www.tei-c.org/ns/1.0",
    "xml": "http://www.w3.org/XML/1998/namespace",
}


def file_parser(file):
    with open(file, 'r') as f:
        text = f.read()
    return text


def remove_namespace(text):
    for ns in NS:
        text = text.replace(ns, '')
    return text


def replace_string(text):
    text = text.replace("&", "&amp;")
    return text


if __name__ == '__main__':
    for file in tqdm.tqdm(source_glob, total=len(source_glob)):
        text = file_parser(file)
        text = remove_namespace(text)
        text = replace_string(text)
        output_path = os.path.join(
            SOURCE_DIR,
            os.path.basename(file).replace('.xml', '_modified.xml'))
        with open(output_path, 'w') as f:
            f.write(text)
