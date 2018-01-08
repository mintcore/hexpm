defmodule Hexpm.Web.API.PackageController do
  use Hexpm.Web, :controller

  plug :maybe_fetch_package when action in [:show]
  plug :maybe_authorize, [domain: "api", fun: &repository_access/2] when action in [:show]

  @sort_params ~w(name recent_downloads total_downloads inserted_at updated_at)

  def index(conn, params) do
    # TODO: Handle /repos/:repo/ and /
    repositories = Users.all_repositories(conn.assigns.current_user)
    page = Hexpm.Utils.safe_int(params["page"])
    search = Hexpm.Utils.parse_search(params["search"])
    sort = sort(params["sort"])
    packages = Packages.search_with_versions(repositories, page, 100, search, sort)

    when_stale(conn, packages, [modified: false], fn conn ->
      conn
      |> api_cache(:public)
      |> render(:index, packages: packages)
    end)
  end

  def show(conn, _params) do
    # TODO: Show flash if private package and repository does not have active billing
    if package = conn.assigns.package do
      when_stale(conn, package, fn conn ->
        package = Packages.preload(package)
        package = %{package | owners: Owners.all(package, :emails)}

        conn
        |> api_cache(:public)
        |> render(:show, package: package)
      end)
    else
      not_found(conn)
    end
  end

  defp sort(nil), do: sort("name")
  defp sort("downloads"), do: sort("total_downloads")
  defp sort(param), do: Hexpm.Utils.safe_to_atom(param, @sort_params)
end
