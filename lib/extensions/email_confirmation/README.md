# PowEmailConfirmation

This extension will send an e-mail confirmation link when the user registers, and when the user changes their e-mail. It requires that the user schema has an `:email` field.

Users won't be signed in when they register, and can't sign in until the e-mail has been confirmed. The confirmation e-mail will be sent every time the sign in fails. The user will be redirected to `after_registration_path/1` and `after_sign_in_path/1` accordingly.

When users are already registered, the e-mail won't be changed for a user until the user has clicked the e-mail confirmation link.

## Installation

Follow the instructions for extensions in [README.md](../../../README.md), and set `PowEmailConfirmation` in the `:extensions` list.

## Configuration

Add the following section to your `WEB_PATH/templates/pow/registration/edit.html.eex` template (you may need to generate the templates first) after the `pow_user_id_field` field:

```elixir
<%= if @changeset.data.unconfirmed_email do %>
  <div>
    <p>Click the link in the confirmation email to change your email to <%= @changeset.data.unconfirmed_email %></span>.</p>
  </div>
<% end %>
```

### Routes

The `PowEmailConfirmation.Phoenix.Routes.after_halted_registration_path/1` and `PowEmailConfirmation.Phoenix.Routes.after_halted_sign_in_path/1` routes are used when halting unconfirmed e-mails registration and sign in. These can be overridden in your custom `MyAppWeb.Pow.Routes` module.

## Prevent persistent session sign in

To prevent that `PowPeristentSession` creates a new persistent session when the email hasn't been confirmed, `PowEmailConfirmation` should be placed first in the extensions list. It'll halt the connection.

## Test and seed

If you want your user to be automatically confirmed in test and seed, you just have to call: `PowEmailConfirmation.Ecto.Context.confirm_email(user, otp_app: :my_app)`

You can also update or insert the row directly and set `email_confirmed_at: DateTime.utc_now()`.

## Note on PowInvitation

When a user is invited with [PowInvitation](../invitation/README.md), the email will only be required confirmed if the invited user decides to change their email when accepting the invitation.
