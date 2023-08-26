import click

# To run the app. From your fav CLI tool, run python3 {script file name}.py


@click.command(help="This is a sample  click application.")
@click.option("--name", "-n", prompt="Please enter user name", help="User name", default="User")
@click.option("--color", "-c", prompt="Please enter  user color", help="User's color", required=1)
def hello(name, color):
    # click.echo(click.style(
    #     f"Hello {name}!, your color is {color}", fg=color.lower()))
    print(f"Hello {name}!, your color is {color.lower()}")


if __name__ == "__main__":
    hello()
