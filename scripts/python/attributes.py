import glob
import tqdm
import os
from acdh_tei_pyutils.utils import previous_and_next
from acdh_tei_pyutils.tei import TeiEnricher


def add_base_id_next_prev(glob_pattern, base_value):
    """Console script add @xml:base, @xml:id and @prev @next attributes to
    root element"""
    files = sorted(glob.glob(glob_pattern))

    for prev_value, current, next_value in tqdm.tqdm(
        previous_and_next(files), total=len(files)
    ):
        doc = TeiEnricher(current)
        id_value = os.path.split(current)[1]
        if prev_value:
            prev_id = os.path.split(prev_value)[1]
        else:
            prev_id = None
        if next_value:
            next_id = os.path.split(next_value)[1]
        else:
            next_id = None
        doc.add_base_and_id(base_value, id_value, prev_id, next_id)
        doc.tree_to_file(file=current)


input_dir = "./data/editions/A*.xml"
base_value = "https://abacus.acdh.oeaw.ac.at"

add_base_id_next_prev(input_dir, base_value)

input_dir = "./data/editions/tmp/*.xml"

add_base_id_next_prev(input_dir, base_value)
