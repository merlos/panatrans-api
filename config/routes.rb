# The MIT License (MIT)
# 
# Copyright (c) 2015 Juan M. Merlos, panatrans.org
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

Rails.application.routes.draw do
   get ':controller/since/:seconds_since_epoc', to: :since, constraints: { controller: /v1\/(stop_sequences)\//, seconds_since_epoc: /[0-9]+/},  defaults: { format: 'json' } 
  
  namespace :v1 do
    get "/routes/with_trips", to: "routes#with_trips",  defaults: { format:'json' }
    
    get '/stops/nearby/', to: 'stops#nearby', constraints: {lat: /[\d\.]+/, lon: /[\d\.]+/, radius: /[\d]+/}, defaults: { format: 'json' }
    
    delete "/stop_sequences/trip/:trip_id/stop/:stop_id",  to: "stop_sequences#destroy_by_trip_and_stop",  constraints: {strop_id: /[0-9]+/, trip_id: /[0-9]+/}, defaults: { format:'json' }
    
    resources :routes, only: [:index, :show, :create, :update, :destroy], defaults: { format: 'json' }
    resources :trips, only: [:index, :show, :create, :update, :destroy], defaults: { format: 'json' }
    resources :stops, only: [:index, :show, :create, :update, :destroy], defaults: { format:'json' }
    resources :stop_sequences, only: [:index, :show, :create, :update, :destroy], defaults: { format: 'json' }
    resources :balance, only: [:show], defaults: {format: 'json'}, constraints: {id: /[0-9]+/}
    
    # Export
    get 'routes/since/:seconds_since_epoc', to: 'routes#since', constraints: {seconds_since_epoc: /[0-9]+/},  defaults: { format: 'json' }
    get 'trips/since/:seconds_since_epoc', to: 'trips#since', constraints: {seconds_since_epoc: /[0-9]+/},  defaults: { format: 'json' }
    get 'stops/since/:seconds_since_epoc', to: 'stops#since', constraints: {seconds_since_epoc: /[0-9]+/},  defaults: { format: 'json' }
    get 'stop_sequences/since/:seconds_since_epoc', to: 'stop_sequences#since', constraints: {seconds_since_epoc: /[0-9]+/},  defaults: { format: 'json' }
    
    
    
    # Angular sends OPTIONS before a POST
    # TODO find a better way to define these routes
    match "/stop_sequences/trip/:trip_id/stop/:stop_id/" => "stop_sequences#options", via: :options, constraints: {strop_id: /[0-9]+/, trip_id: /[0-9]+/}, defaults: { format:'json' }
    match "/stop_sequences/" => "stop_sequences#options", via: :options
    match "/stop_sequences/:id" => "stop_sequences#options", via: :options
    
    match "/routes/" => "routes#options", via: :options
    match "/routes/:id" => "routes#options", via: :options
    
    match "/stops/" => "stops#options", via: :options
    match "/stops/:id" => "stops#options", via: :options
    
    match "/trips/" => "trips#options", via: :options
    match "/trips/:id" => "trips#options", via: :options
    
        
  end
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
