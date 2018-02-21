json.extract! device, :id, :title, :manufacturer, :seller, :dev_class, :dev_model, :serial_number, :parameter, :purchased, :used, :invalided, :branch_id, :custodian, :user, :status, :changed_date, :contacts, :description, :created_at, :updated_at
json.url device_url(device, format: :json)
