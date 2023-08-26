from SampleClick import hello
from click.testing import CliRunner


def test_hello():
    runner = CliRunner()
    result = runner.invoke(hello, ["-n", "test-user", "-c", "blue"])
    assert "testuser" in result.output
