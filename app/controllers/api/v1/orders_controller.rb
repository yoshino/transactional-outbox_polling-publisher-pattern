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

        if order.valid?
          ActiveRecord::Base.transaction do
            order.save
            order.order_events.create(event_type: 'post_order', order_status: order.status)
          end

          render json: { data: order }
        else
          render json: { data: order.errors }
        end
      end

      def destroy
        order = Order.find(params[:id])

        ActiveRecord::Base.transaction do
          order.order_events.create(event_type: 'delete_order', order_status: order.status)
          order.destroy!
        end

        render json: { data: order }
      end

      def update
        order = Order.find(params[:id])
        order.assign_attributes(order_params)

        if order.valid?
          ActiveRecord::Base.transaction do
            order.update(order_params)
            order.order_events.create(event_type: 'put_order', order_status: order.status)
          end

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
