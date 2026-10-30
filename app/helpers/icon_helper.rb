module IconHelper
  ICONS = {
    arrow: '<path d="M5 12h14"></path><path d="m14 7 5 5-5 5"></path>',
    play: '<path d="m8 5 11 7-11 7V5Z"></path>',
    user: '<circle cx="12" cy="8" r="4"></circle><path d="M4 21a8 8 0 0 1 16 0"></path>',
    target: '<circle cx="12" cy="12" r="9"></circle><circle cx="12" cy="12" r="4"></circle><path d="M12 3v2M21 12h-2M12 21v-2M3 12h2"></path>',
    pulse: '<path d="M3 12h4l2-7 4 14 2-7h6"></path>',
    check: '<path d="m5 12 4 4L19 6"></path>',
    instagram: '<rect x="3" y="3" width="18" height="18" rx="5"></rect><circle cx="12" cy="12" r="4"></circle><path d="M17.5 6.5h.01"></path>'
  }.freeze

  def icon(name, css_class:)
    tag.svg(
      ICONS.fetch(name).html_safe,
      class: css_class,
      aria: { hidden: true },
      fill: "none",
      viewBox: "0 0 24 24",
      stroke: "currentColor",
      "stroke-linecap": "round",
      "stroke-linejoin": "round",
      "stroke-width": "1.8"
    )
  end
end
