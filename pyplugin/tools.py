def normalize_string(a_text):
    return " ".join(a_text.replace("\n", " ").replace("\r", " ").split())
