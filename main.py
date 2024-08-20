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
    # Set up logging format
    logging.basicConfig(
        format=(
            # Timestamp
            "%(asctime)s "
            # Severity of log entry
            "%(levelname)s "
            # module/function:line:
            "%(module)s/%(funcName)s:%(lineno)d: "
            # message
            "%(message)s"
        ),
        level=logging_level,
    )


def testable_function(operand1: int, operand2: int) -> int:
    """An example function to be tested in main_test.py.  Adds its parameters."""
    return operand1 + operand2


def main() -> None:
    """Main function"""
    args = parse_args()
    setup_logging(args)

    logging.debug("TODO: Put code here :)")


if __name__ == "__main__":
    main()
