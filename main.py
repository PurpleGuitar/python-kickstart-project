""" TODO: Purpose of this program """

# Standard imports
from argparse import ArgumentParser, Namespace
import logging

# Third party imports

# Project imports


def parse_args() -> Namespace:
    """Parse command line arguments"""
    parser = ArgumentParser(description="TODO: Description of this script")
    parser.add_argument("--trace", action="store_true", help="Enable tracing output")
    return parser.parse_args()


def setup_logging(args: Namespace) -> None:
    """Setup logging for script."""

    # read logging level from args
    if args.trace:
        logging_level = logging.DEBUG
    else:
        logging_level = logging.WARNING

    # Set up
    logging.basicConfig(
        format=(
            "%(asctime)s "
            "%(levelname)s "
            "%(module)s/%(funcName)s:%(lineno)d: "
            "%(message)s"
        ),
        level=logging_level,
    )


def main() -> None:
    """Main function"""
    args = parse_args()
    setup_logging(args)

    logging.debug("TODO: Put code here :)")


if __name__ == "__main__":
    main()
