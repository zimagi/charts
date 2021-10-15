from posixpath import join
from typing import Dict, List
from dataclasses import dataclass
from os import path

import yaml
import click


@dataclass
class Version:
    chart_directory: str
    tag: str
    chart_file_path: str = "Chart.yaml"
    value_file_path: str = "values.yaml"

    def _open_yaml_file(self, file_path: str) -> Dict[str, any]:
        with open(file_path, "rb") as yaml_file:
            return yaml.load(yaml_file.read(), Loader=yaml.SafeLoader)

    def _write_yaml_file(self, payload: Dict[str, any], file_path: str) -> None:
        with open(file_path, "w") as yaml_file:
            yaml.dump(payload, yaml_file, default_flow_style=False)

    def update_tag(self, tag: str) -> None:
        values_file_path = path.join(self.chart_directory, self.value_file_path)
        values_yaml = self._open_yaml_file(values_file_path)
        values_yaml["image"]["tag"] = tag
        self._write_yaml_file(values_yaml, values_file_path)

    def current_chart_version(self) -> str:
        return self._open_yaml_file(
            path.join(self.chart_directory, self.chart_file_path)
        )["version"]

    def current_tag(self) -> str:
        return self._open_yaml_file(
            path.join(self.chart_directory, self.value_file_path)
        )["image"]["tag"]

    def increment_chart_version(self) -> None:
        chart_file_path = path.join(self.chart_directory, self.chart_file_path)
        chart_yaml = self._open_yaml_file(chart_file_path)
        chart_yaml["version"] = self.increment_version_number(chart_yaml["version"])
        self._write_yaml_file(chart_yaml, chart_file_path)

    def update_chart_file(self) -> None:
        with open(
            path.join(self.chart_directory, self.chart_file_path), "wb"
        ) as chart_file:
            pass

    @staticmethod
    def increment_version_number(version: str, inc: int = 1) -> str:
        macro, minor, micro = version.split(".")
        incremented_micro = str(int(micro) + inc)
        return ".".join([macro, minor, incremented_micro])


@click.command()
@click.option("-c", "--chart-directory", type=str, required=True)
@click.option("-t", "--tag", type=str, required=True)
@click.option("-C", "--chart-file-path", type=str, required=False, default="Chart.yaml")
@click.option(
    "-v", "--values-file-path", type=str, required=False, default="values.yaml"
)
def main(chart_directory, tag, chart_file_path, values_file_path):
    version = Version(chart_directory, tag, chart_file_path, values_file_path)
    version.increment_chart_version()
    version.update_tag(tag)


if __name__ == "__main__":
    main()
