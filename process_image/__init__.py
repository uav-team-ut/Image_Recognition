def get_targets(image):
    """Return a list of targets from an image.

    Args:
        image: .png as a base64 string

    Returns:
        A list of targets.
    """

    return [{
        "original_image": image
    }]
