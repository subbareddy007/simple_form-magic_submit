require "simple_form/magic_submit/version"

module SimpleForm
  module MagicSubmit

    def submit_retry_button(*args, &block)
      template.content_tag :div, :class => "form-actions" do
        options = args.extract_options!
        options[:"data-loading-text"] ||= translate_key(:loading)
        options[:class] = ['btn-primary', 'btn-submit', options[:class]].compact
        options[:id] ||= "submit_#{object_scope}"
        args << options
        if cancel = options.delete(:cancel)
          I18n.t("simple_form.magic_submit.cancel.format",
            submit_button: submit(translate_key, *args, &block).html_safe,
            cancel_link: template.link_to(I18n.t('simple_form.magic_submit.cancel.cancel').html_safe, cancel)
          )
        else
          submit(translate_key, *args, &block)
        end.html_safe
      end
    end

  private

    def object_scope
      self.object.class.model_name.underscore
    end

    def translate_key(key = nil)
      op = self.object.new_record? ? :create : :save
      key ||= self.object.errors.count > 0 ? :retry : :submit
      I18n.t("simple_form.magic_submit.#{object_scope}.#{op}.#{key}",
        default: [:"simple_form.magic_submit.default.#{op}.#{key}", :"helpers.submit.#{op}"],
        model: self.object.class.model_name.titlecase
      ).html_safe
    end

  end
end

SimpleForm::FormBuilder.send :include, SimpleForm::MagicSubmit
I18n.load_path += Dir.glob(File.dirname(__FILE__) + "../../locales/*.{rb,yml}")