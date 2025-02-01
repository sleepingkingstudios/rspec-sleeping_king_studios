<li>
  <a href="#overview">Overview</a>
  {% assign metadata = include.definition.metadata %}
  {% if metadata.examples.size > 0 or metadata.see.size > 0 or metadata.authors.size > 0 or metadata.since.size > 0 or metadata.versions.size > 0 %}
  <ul style="margin-bottom: 0px;">
    {% if metadata.examples.size > 0 %}
    <li>
      <a href="#examples">Examples</a>
    </li>
    {% endif %}
    {% if metadata.see.size > 0 %}
    <li>
      <a href="#see-also">See Also</a>
    </li>
    {% endif %}
    {% if metadata.authors.size > 1 %}
    <li>
      <a href="#authors">Authors</a>
    </li>
    {% elsif metadata.authors.size > 0 %}
    <li>
      <a href="#author">Author</a>
    </li>
    {% endif %}
    {% if metadata.since.size > 0 %}
    <li>
      <a href="#since">Since</a>
    </li>
    {% endif %}
    {% if metadata.versions.size > 1 %}
    <li>
      <a href="#versions">Versions</a>
    </li>
    {% elsif metadata.versions.size > 0 %}
    <li>
      <a href="#version">Version</a>
    </li>
    {% endif %}
  </ul>
  {% endif %}
</li>
