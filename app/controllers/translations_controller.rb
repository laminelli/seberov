# Originally from https://medium.com/ruby-on-rails/maintainable-i18n-with-rails-and-angularjs-f3b2542a1980
class TranslationsController < ApplicationController
  respond_to :json

  def show
    @locale = params[:id].to_sym

    @translations = I18n.with_locale(@locale) do
      I18n.backend.send(:translations)[@locale]
    end

    render json: @translations
  end
end
