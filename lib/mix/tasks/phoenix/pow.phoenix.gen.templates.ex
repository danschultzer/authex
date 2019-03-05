defmodule Mix.Tasks.Pow.Phoenix.Gen.Templates do
  @shortdoc "Generates Pow views and templates"

  @moduledoc """
  Generates pow templates for Phoenix.

      mix pow.phoenix.gen.templates

  ## Arguments

    * `--context-app MyApp` app to use for path and module names
  """
  use Mix.Task

  alias Mix.{Pow, Pow.Phoenix}

  @switches [context_app: :string]
  @default_opts []
  @mix_task "pow.phoenix.gen.templates"

  @doc false
  def run(args), do: run(args, Pow.schema_options_from_args())
  def run(args, schema_opts) do
    Pow.no_umbrella!(@mix_task)
    Pow.ensure_phoenix!(@mix_task, args)

    args
    |> Pow.parse_options(@switches, @default_opts)
    |> create_template_files()
    |> print_shell_instructions(schema_opts)
  end

  @templates [
    {"registration", ~w(new edit)},
    {"session", ~w(new)}
  ]

  defp create_template_files({config, _parsed, _invalid}) do
    structure    = Phoenix.parse_structure(config)
    context_base = structure[:context_base]
    web_module   = structure[:web_module]
    web_prefix   = structure[:web_prefix]

    Enum.each(@templates, fn {name, actions} ->
      Phoenix.create_view_file(Elixir.Pow, name, web_module, web_prefix)
      Phoenix.create_templates(Elixir.Pow, name, web_prefix, actions)
    end)

    %{context_base: context_base, web_module: web_module}
  end

  defp print_shell_instructions(%{context_base: context_base, web_module: web_base}, %{schema_name: schema_name}) do
    Mix.shell.info("""
    Pow Phoenix templates and views has been generated.

    Please add `web_module: #{inspect(web_base)}` to your configuration.

    config :#{Macro.underscore(context_base)}, :pow,
      user: #{inspect(context_base)}.#{schema_name},
      repo: #{inspect(context_base)}.Repo,
      web_module: #{inspect(web_base)}
    """)
  end
end
