import sys
from pathlib import Path
import ruamel.yaml

yaml_file = Path(sys.argv[1])

yaml = ruamel.yaml.YAML()
yaml.preserve_quotes = True
# uncomment and adapt next line in case defaults don't match your indentation
# yaml.indent(mapping=4, sequence=4, offset=2)

data = yaml.load(yaml_file)
version = sys.argv[2]
if isinstance(data['version'], float):
    version = float(version)
data['version'] = version

yaml.dump(data, yaml_file)
