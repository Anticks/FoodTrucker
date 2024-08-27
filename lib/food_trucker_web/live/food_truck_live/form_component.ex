defmodule FoodTruckerWeb.FoodTruckLive.FormComponent do
  use FoodTruckerWeb, :live_component

  alias FoodTrucker.Vendor

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage food_truck records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="food_truck-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >

        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:permit]} type="text" label="Permit" />
        <.input field={@form[:food_item_description]} type="text" label="Food item description" />
        <.input field={@form[:facility_type]} type="text" label="Facility type" />
        <.input field={@form[:status]} type="text" label="Status" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Food truck</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{food_truck: food_truck} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Vendor.change_food_truck(food_truck))
     end)}
  end

  @impl true
  def handle_event("validate", %{"food_truck" => food_truck_params}, socket) do
    changeset = Vendor.change_food_truck(socket.assigns.food_truck, food_truck_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"food_truck" => food_truck_params}, socket) do
    save_food_truck(socket, socket.assigns.action, food_truck_params)
  end

  defp save_food_truck(socket, :edit, food_truck_params) do
    case Vendor.update_food_truck(socket.assigns.food_truck, food_truck_params) do
      {:ok, food_truck} ->
        notify_parent({:saved, food_truck})

        {:noreply,
         socket
         |> put_flash(:info, "Food truck updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_food_truck(socket, :new, food_truck_params) do
    case Vendor.create_food_truck(food_truck_params) do
      {:ok, food_truck} ->
        notify_parent({:saved, food_truck})

        {:noreply,
         socket
         |> put_flash(:info, "Food truck created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
