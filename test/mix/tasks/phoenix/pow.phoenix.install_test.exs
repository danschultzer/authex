defmodule Mix.Tasks.Pow.Phoenix.InstallTest do
  use Pow.Test.Mix.TestCase

  alias Mix.Tasks.Pow.Phoenix.Install

  defmodule Repo do
    def __adapter__, do: true
    def config, do: [priv: "", otp_app: :pow]
  end

  @tmp_path       Path.join(["tmp", inspect(Install)])
  @options        ["-r", inspect(Repo)]
  @web_path       Path.join(["lib", "pow_web"])
  @templates_path Path.join([@web_path, "templates", "pow"])
  @views_path     Path.join([@web_path, "views", "pow"])

  setup do
    File.rm_rf!(@tmp_path)
    File.mkdir_p!(@tmp_path)

    :ok
  end

  test "default" do
    File.cd!(@tmp_path, fn ->
      Install.run(@options)

      refute File.exists?(@templates_path)
      refute File.exists?(@views_path)

      assert_received {:mix_shell, :info, ["Pow has been installed in your phoenix app!" <> msg]}
      assert msg =~ "config :pow, :pow,"
      assert msg =~ "user: Pow.Users.User,"
      assert msg =~ "plug Pow.Plug.Session, otp_app: :pow"
      assert msg =~ "use Pow.Phoenix.Router"
      assert msg =~ "pow_routes()"
    end)
  end

  test "with schema name" do
    options = @options ++ ~w(Accounts.User)

    File.cd!(@tmp_path, fn ->
      Install.run(options)

      assert_received {:mix_shell, :info, [msg]}
      assert msg =~ "config :pow, :pow,"
      assert msg =~ "user: Pow.Accounts.User,"
      assert msg =~ "plug Pow.Plug.Session, otp_app: :pow"
      assert msg =~ "use Pow.Phoenix.Router"
      assert msg =~ "pow_routes()"
    end)
  end

  test "with templates" do
    options = @options ++ ~w(--templates)

    File.cd!(@tmp_path, fn ->
      Install.run(options)

      assert File.exists?(@templates_path)
      assert [_one, _two] = File.ls!(@templates_path)
      assert File.exists?(@views_path)
      assert [_one, _two] = File.ls!(@views_path)
    end)
  end

  test "with extension templates" do
    options = @options ++ ~w(--templates --extension PowResetPassword --extension PowEmailConfirmation)

    File.cd!(@tmp_path, fn ->
      Install.run(options)

      assert File.exists?(@templates_path)
      reset_password_templates = Path.join(["lib", "pow_web", "templates", "pow_reset_password"])
      assert [_one] = File.ls!(reset_password_templates)
      reset_password_views = Path.join(["lib", "pow_web", "views", "pow_reset_password"])
      assert File.exists?(reset_password_views)
      assert [_one] = File.ls!(reset_password_views)
    end)
  end

  test "with `:context_app`" do
    options = @options ++ ~w(--context-app test)
    File.cd!(@tmp_path, fn ->
      Install.run(options)

      assert_received {:mix_shell, :info, ["Pow has been installed in your phoenix app!" <> msg]}
      assert msg =~ "plug Pow.Plug.Session, otp_app: :test"
    end)
  end

  test "raises error in app with no phoenix dep" do
    File.cd!(@tmp_path, fn ->
      File.write!("mix.exs", """
      defmodule MyApp.MixProject do
        use Mix.Project

        def project do
          []
        end
      end
      """)

      Mix.Project.in_project(:my_app, ".", fn _ ->
        assert_raise Mix.Error, "mix pow.phoenix.install can only be run inside an application directory that has :phoenix as dependency", fn ->
          Install.run([])
        end
      end)
    end)
  end
end
