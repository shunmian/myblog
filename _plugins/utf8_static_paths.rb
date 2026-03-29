module Utf8StaticPaths
  private

  def coerce_utf8(path)
    return path if path.encoding == Encoding::UTF_8

    candidate = path.dup.force_encoding(Encoding::UTF_8)
    return candidate if candidate.valid_encoding?

    path.encode(Encoding::UTF_8)
  end

  public

  def unescape_path(path)
    super(coerce_utf8(path))
  end
end

Jekyll::URL.singleton_class.prepend(Utf8StaticPaths)
