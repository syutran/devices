Rails.application.routes.draw do
  get 'manage/index', to: 'manage#index', as: 'manage'
  get 'manage/turnup_list', to: 'manage#turnup_list', as: 'manage_turnup_list'
  get 'manage/stock_list', to: 'manage#stock_list', as: 'manage_stock_list'
  get 'manage/change_status/:id', to: 'manage#change_status', as: :manage_change_status
  get 'manage/turnoff_list', to: 'manage#turnoff_list', as: 'manage_turnoff_list'
  get 'manage/agree_turnup/:id', to: 'manage#agree_turnup', as: 'manage_agree_turnup'
  get 'manage/show_device/:id', to: 'manage#show_device', as: 'manage_device'
  get 'manage/allot/:id', to: 'manage#allot', as: 'manage_allot'
  patch 'manage/put_allot/:id', to: 'manage#put_allot', as: 'manage_put_allot'
  root to: 'welcome#index'

  get 'sessions/new'

  # 验证码
  # mount RuCaptcha::Engine => "/rucaptcha"

  resources :users do
    member do
      get 'edit_avatar'
      post 'update_avatar'
    end
  end
  
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  get '/devices/drop_versions/:id' => 'devices#drop_versions', as: 'drop_versions'
  delete '/logout', to: 'sessions#destroy'
  # root to: 'welcome#index'
  # root 'sessions#new'

  resources :categories
  get '/devices/history', to: 'devices#history', as: :devices_history
  put 'devices/change_status/:id', to: 'devices#change_status', as: :device_change_status

  resources :devices
  get 'devices/edit_avatar/:id', to: 'devices#edit_avatar', as: :edit_device_avatar
  patch 'devices/update_avatar/:id', to: 'devices#update_avatar', as: :update_device_avatar
  resources :branches
  resources :password_resets
  get '/devices/branch_devices/:id' => 'devices#branch_devices',  :as => "branch_devices"
  get '/devices/branch_devices_to_xlsx/:id' => 'devices#branch_devices_to_xlsx',  :as => "branch_devices_to_xlsx"
  get '/categories/to_xlsx/:id', to: 'categories#to_xlsx', as: :categories_toxlsx
  get '/categories/all_to_xlsx/:id', to: 'categories#all_to_xlsx', as: :categories_all_toxlsx
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
