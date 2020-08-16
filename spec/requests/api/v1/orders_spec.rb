require 'rails_helper'

describe 'Order API', type: :request  do
  describe 'Get /orders' do
    subject { get '/api/v1/orders' }

    before do
      create_list(:order, 10)
    end

    it do
      subject

      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['data'].count).to eq 10
    end
  end

  describe 'Get /orders/:id' do
    subject { get "/api/v1/orders/#{order.id}" }

    let!(:order) { create(:order) }

    it do
      subject

      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['data']['id']).to eq order.id
    end
  end

  describe 'Post /orders' do
    subject { post '/api/v1/orders', params: { order: { status: status }} }

    context 'success' do
      let(:status) { 'preparing' }

      it do
        expect { subject }.to change { Order.count }.by(1)
                          .and change { OrderEvent.count }.by(1)
        expect(OrderEvent.where(order_id: JSON.parse(response.body)['data']['id'], event_type: 'create_order').exists?).to be_truthy
      end
    end

    context 'error' do
      let(:status) { nil }

      it do
        expect { subject }.to change { Order.count }.by 0
        expect(JSON.parse(response.body)['data']).to eq({ 'status' => ["can't be blank"] })
      end
    end
  end

  describe 'Delete /orders/:id' do
    subject { delete "/api/v1/orders/#{order.id}" }

    let!(:order) { create(:order) }

    it do
      expect { subject }.to change { Order.count }.by(-1)
                        .and change { OrderEvent.count }.by(1)
      expect(Order.where(id: order.id).exists?).to be_falsy
      expect(OrderEvent.where(order_id: order.id, event_type: 'delete_order').exists?).to be_truthy
    end
  end

  describe 'Put /orders/:id' do
    subject { put "/api/v1/orders/#{order.id}", params: { order: { status: status }} }

    let!(:order) { create(:order) }

    context 'success' do
      let(:status) { 'ready' }

      it do
        expect { subject }.to change { Order.count }.by(0)
                          .and change { OrderEvent.count }.by(1)
        expect(JSON.parse(response.body)['data']['status']).to eq 'ready'
        expect(OrderEvent.where(order_id: order.id, event_type: 'put_order').exists?).to be_truthy
      end
    end

    context 'error' do
      let(:status) { nil }

      it do
        expect { subject }.to change { Order.count }.by 0
        expect(JSON.parse(response.body)['data']).to eq({ 'status' => ["can't be blank"] })
      end
    end
  end

end
