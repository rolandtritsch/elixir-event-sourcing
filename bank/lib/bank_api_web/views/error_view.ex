defmodule BankAPIWeb.ErrorView do
  use BankAPIWeb, :view

  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  def render("422.json", assigns) do
    %{
      errors: %{
        message: assigns[:message] || "Unprocessable entity"
      }
    }
  end
end
