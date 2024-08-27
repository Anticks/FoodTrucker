defmodule FoodTruckerWeb.FoodTruckLive.Show do
  use FoodTruckerWeb, :live_view

  alias FoodTrucker.Vendor

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:food_truck, Vendor.get_food_truck!(id))}
  end

  defp page_title(:show), do: "Show Food truck"
  defp page_title(:edit), do: "Edit Food truck"
end
