module ApplicationHelper
  def instagram_url
    HomePage::INSTAGRAM_URL
  end

  def field_classes(record, attribute, extra = nil)
    border = if record.errors.include?(attribute)
      "border-red-300/60 focus:border-red-300"
    else
      "border-white/15 focus:border-cyan-400"
    end

    [ "field-control w-full rounded-xl border bg-white/[0.06] px-4 text-base font-normal text-white outline-none transition placeholder:text-slate-500 focus:bg-white/[0.09]", border, extra ].compact.join(" ")
  end

  def field_errors(record, attribute)
    return if record.errors[attribute].empty?

    tag.span(record.errors[attribute].to_sentence, class: "text-sm font-medium text-red-300")
  end
end
