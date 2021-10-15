from click.testing import CliRunner
from version_updater import main
import hashlib


def hash_file(file_path):
    buf_size = 65536
    sha1 = hashlib.sha1()

    with open(file_path, "rb") as file:
        while True:
            data = file.read(buf_size)
            if not data:
                break
            sha1.update(data)

    return sha1.hexdigest()


def test_version_updater():
    # Arrange
    current_content_of_chart_file = hash_file("./test_Chart.yaml")
    current_content_of_values_file = hash_file("./test_values.yaml")
    runner = CliRunner()

    # Act
    result = runner.invoke(
        main,
        ["-c", ".", "-t", "test", "-C", "test_Chart.yaml", "-v", "test_values.yaml"],
    )
    actual_content_of_chart_file = hash_file("./test_Chart.yaml")
    actual_content_of_values_file = hash_file("./test_values.yaml")

    # Assert
    assert result.exit_code == 0
    assert current_content_of_chart_file != actual_content_of_chart_file
    assert current_content_of_values_file != actual_content_of_values_file
