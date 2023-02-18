import os
import re
import click


def load_file(file_path):
    content = None
    if os.path.exists(file_path):
        with open(file_path, 'r') as file:
            content = file.read()
    return content

def save_file(file_path, content):
    with open(file_path, 'w') as file:
        file.write(content)


class Chart:

    def __init__(self, chart_directory):
        self.chart_directory = chart_directory


    def update_chart_info(self, tag):
        chart_file_path = os.path.join(self.chart_directory, "Chart.yaml")
        chart_file_content = load_file(chart_file_path)

        matches = re.search(r'version:\s*(\d+\.\d+\.\d+)', chart_file_content)
        major, minor, patch = matches.group(1).split('.')

        chart_file_content = re.sub(
            r'version:\s*\d+\.\d+\.\d+',
            "version: {}.{}.{}".format(major, minor, int(patch) + 1),
            chart_file_content
        )
        chart_file_content = re.sub(
            r'appVersion:\s*\d+\.\d+\.\d+(\-[0-9a-zA-Z\-\.]+)?',
            "appVersion: {}".format(tag),
            chart_file_content
        )
        save_file(chart_file_path, chart_file_content)


    def update_values(self, tag):
        values_file_path = os.path.join(self.chart_directory, "values.yaml")
        values_file_content = load_file(values_file_path)

        values_file_content = re.sub(
            r'tag:\s*\d+\.\d+\.\d+(\-[0-9a-zA-Z\-\.]+)?',
            "tag: {}".format(tag),
            values_file_content
        )
        save_file(values_file_path, values_file_content)


@click.command()
@click.option("-d", "--chart-directory", type = str, required = True)
@click.option("-t", "--tag", type = str, required = True)
def main(chart_directory, tag):
    chart = Chart(chart_directory)
    chart.update_chart_info(tag)
    chart.update_values(tag)


if __name__ == "__main__":
    main()
