module Api
  module V1
    class OrdersController < ApplicationController
      def index
        orders = Order.order(created_at: :desc)
        render json: { data: orders }
      end

      def show
        order = Order.find(params[:id])
        render json: { data: order }
      end

      def create
        order = Order.new(order_params)

        if order.save
          render json: { data: order }
        else
          render json: { data: order.errors }
        end
      end

      def destroy
        order = Order.find(params[:id])
        order.destroy!
        render json: { data: order }
      end

      def update
        order = Order.find(params[:id])

        if order.update(order_params)
          render json: { data: order }
        else
          render json: { data: order.errors }
        end
      end

      private

      def order_params
        params.require(:order).permit(:status)
      end
    end
  end
end
