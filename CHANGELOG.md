# Changelog

## v1.0.3 (TBA)

* Correct shell instructions for `mix pow.install` task with custom schema
* Deprecated `Pow.Extension.Config.underscore_extension/1`
* Deprecated `:messages_backend_fallback` setting for extension controllers
* Removed deprecated macro `router_helpers/1` in `Pow.Phoenix.Controller`
* Fixed bug in `Pow.Extension.Phoenix.Router.Base` and `Pow.Extension.Phoenix.Messages` where the full extension name wasn't used to namespace methods

## v1.0.2 (2019-02-28)

* Added flash error message about e-mail confirmation for when user changes e-mail with PowEmailConfirmation enabled
* Added `new_password_changeset/3` and `confirm_password_changeset/3` to `Pow.Ecto.Schema.Changeset`
* Redis cache store backend guide
* Correct shell instructions for `mix pow.phoenix.gen.templates` task
* Only load environment config in `Pow.Config.get/3` when no key is set in the provided config
* Fixed issue in `Pow.Store.Backend.MnesiaCache.keys/1` and `Pow.Store.Backend.EtsCache.keys/1` so they now return keys without namespace
* `Pow.Store.Backend.MnesiaCache.put/3` now raises an error if TTL is not provided

### Breaking changes

* `PowResetPassword.Plug.reset_password_token/1` has been removed

## v1.0.1 (2019-01-27)

* `pow.extension.ecto.gen.migrations` mix task will output warning when a migration file won't be generated for any particular extension
* Leading and trailing whitespace is removed from the user id field value (in addition to forced lower case)
* An exception is raised when `pow_routes/0` or `pow_extension_routes/0` are used inside router scopes with aliases
* Mail view templates assigns now has `[user: user, conn: conn]` along with the template specific assigns
* Mail view subject methods now gets the same assigns passed as mail view template assigns instead of only `[conn: conn]`
* Added `pow_registration_routes/0`, `pow_session_routes/0` and `pow_scope/1` macros to the router module
* Added guide on how to disable registration

## v1.0.0 (2018-11-18)

* Phoenix 1.4 support
* Ecto 3.0 support