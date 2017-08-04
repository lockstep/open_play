module MetaTagHelper
  def meta_tags(title:, type: 'website', url: current_full_url,
                image:, description:)
    facebook(title: title,
             type: type,
             url: url,
             image: image,
             description: description).concat(
               twitter(title: title,
                       image: image,
                       description: description)
             ).html_safe
  end

  private

  def facebook(title:, url:, type:, image:, description:)
    <<-META
      <meta property='og:title' content="#{cleanup(title)}"/>
      <meta property='og:type' content="#{type}"/>
      <meta property='og:image' content="#{image}"/>
      <meta property="og:image:width" content="300"/>
      <meta property="og:image:height" content="300"/>
      <meta property='og:url' content="#{url}"/>
      <meta property='og:site_name' content="Openplay.io"/>
      <meta property='og:description' content="#{cleanup(description)}"/>
    META
  end

  def twitter(title:, type: 'summary', image:, description:)
    <<-META
      <meta name='twitter:card' content="#{type}">
      <meta name='twitter:site' content="@Openplay_io">
      <meta name='twitter:title' content="#{cleanup(title)}">
      <meta name='twitter:description' content="#{cleanup(description)}">
      <meta name='twitter:image' content="#{image}">
    META
  end

  def cleanup(text)
    return '' if text.nil?
    strip_tags(text).gsub('"', '&#34;')
  end
end
