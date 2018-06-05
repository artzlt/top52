require "sidekiq/web"
require "admin_constraint"

Octoshell::Application.routes.draw do
  #root :to => redirect('/top50_objects')
  #root 'top50_objects#index'
  # This line mounts Wiki routes at /wiki by default.
  mount Wiki::Engine, :at => "/wiki"

  # This line mounts Statistics routes at /stats by default.
  mount Statistics::Engine, :at => "/admin/stats"

  # This line mounts Sessions's routes at /sessions by default.
  mount Sessions::Engine, :at => "/sessions"

  # This line mounts Support's routes at /support by default.
  mount Support::Engine, :at => "/support"

  # This line mounts Core's routes at /core by default.
  mount Core::Engine, :at => "/core"

  # This line mounts Face's routes at / by default.
  mount Face::Engine, at: "/"

  # This line mounts Authentication's routes at /auth by default.
  mount Authentication::Engine, at: "/auth"

  mount Announcements::Engine, :at => "/announcements"

  # root "face/home#show"
  root :to => redirect('/top50_stats')
  

  resources :users do
    get :login_as, on: :member
    get :return_to_self, on: :member
  end
  resource :profile
  get 'top50_machines/:id/new_form', to: 'top50_machines#new_form', as:'top50_machines_new_form'
  get 'top50_machines/:id/new_form_3', to: 'top50_machines#new_form_3', as:'top50_machines_new_form_3'
  patch 'top50_machines/:id/new_form_3', to: 'top50_machines#new_form_3_save'
  get 'top50_machines/:id/new_form_4', to: 'top50_machines#new_form_4', as:'top50_machines_new_form_4'
  patch 'top50_machines/:id/new_form_4', to: 'top50_machines#new_form_4_save'
  get 'top50_machines/:id/new_form_5', to: 'top50_machines#new_form_5', as:'top50_machines_new_form_5'
  resources :top50_machines
#  resources :top50_objects
  resources :top50_contacts
  resources :top50_vendors
  resources :top50_organizations
  resources :top50_machine_types
  resources :top50_object_types
  resources :top50_objects
  resources :top50_cities
  resources :top50_regions
  resources :top50_countries
  resources :top50_relation_types
  resources :top50_relations
  resources :top50_attributes
  resources :top50_attribute_datatypes
  resources :top50_dictionaries, shallow: true do
	resources :top50_dictionary_elems
  end
  resources :top50_measure_units
  resources :top50_benchmarks
#  resources :top50_attribute_dbval
  resources :top50_attribute_dbvals
  resources :top50_attribute_dicts
  get 'top50_machines_list_tmp/:eid', to: 'top50_machines#list_tmp', as:'top50_machines_list_tmp'
  get 'top50_machines_list_tmp2/:eid', to: 'top50_machines#list_tmp2', as:'top50_machines_list_tmp2'
  get 'top50_machines_list', to: 'top50_machines#list', as:'top50_machines_list'
  get 'top50_machines_archive/:eid', to: 'top50_machines#archive', as:'top50_machines_archive'
  get 'top50_machines_archive/:eid/vendor/:vid', to: 'top50_machines#archive_by_vendor', as:'top50_machines_archive_vendor'
  get 'top50_machines_archive/:eid/vendor/:vid/excl', to: 'top50_machines#archive_by_vendor_excl', as:'top50_machines_archive_vendor_excl'
  get 'top50_machines_archive/:eid/org/:oid', to: 'top50_machines#archive_by_org', as:'top50_machines_archive_org'
  get 'top50_machines_archive/:eid/comp/:oid', to: 'top50_machines#archive_by_proc', as:'top50_machines_archive_proc'
  get 'top50_machines_archive/:eid/compgpu/:oid', to: 'top50_machines#archive_by_gpu', as:'top50_machines_archive_gpu'  
  get 'top50_machines_archive/:eid/compcop/:oid', to: 'top50_machines#archive_by_cop', as:'top50_machines_archive_cop'  
  get 'top50_machines_archive/:eid/comps/:oid', to: 'top50_machines#archive_by_comp', as:'top50_machines_archive_comp'  
  get 'top50_machines_archive/:eid/comp_attrd/:elid', to: 'top50_machines#archive_by_comp_attrd', as:'top50_machines_archive_comp_attrd'  
  get 'top50_machines_archive/:eid/attr/:aid/:elid', to: 'top50_machines#archive_by_attr_dict', as:'top50_machines_archive_attr_dict'
  get 'top50_machines_vendor/:vid', to: 'top50_machines#vendor', as:'top50_machines_vendor'
  get 'top50_machines_org/:oid', to: 'top50_machines#org', as:'top50_machines_org'
  get 'top50_machines_archive', to: 'top50_machines#archive_lists', as:'top50_machines_archive_lists'
  get 'top50_objects/:id/top50_attribute_vals', to: 'top50_objects#attribute_vals', as:'top50_object_top50_attribute_vals'
  get 'top50_machines/:id', to: 'top50_machines#show', as:'top50_machines_show'
  get 'top50_vendors_stats/:thres', to: 'top50_vendors#stats', as:'top50_vendors_stats'
  get 'top50_stats', to: 'top50_machines#stats', as:'top50_stats_def'
  get 'top50_stats/:section', to: 'top50_machines#stats', as:'top50_stats'
  get 'top50_stats/:section/:eid', to: 'top50_machines#stats_per_list', as: 'top50_stats_per_list'
  get 'top50_ext_stats/:eid', to: 'top50_machines#ext_stats', as: 'top50_ext_stats'
  
  post 'top50_objects/:id/top50_attribute_val_dbvals', to: 'top50_objects#create_attribute_val_dbval', as:'top50_object_top50_attribute_val_dbvals'
  get 'top50_objects/:id/top50_attribute_val_dbvals/new', to: 'top50_objects#new_attribute_val_dbval', as:'new_top50_object_top50_attribute_val_dbval'
 
  post 'top50_objects/:id/top50_attribute_val_dicts', to: 'top50_objects#create_attribute_val_dict', as:'top50_object_top50_attribute_val_dicts'
  get 'top50_objects/:id/top50_attribute_val_dicts/new', to: 'top50_objects#new_attribute_val_dict', as:'new_top50_object_top50_attribute_val_dict'

  get 'top50_attribute_dicts/:attr_id/top50_dictionary_elems', to: 'top50_dictionary_elems#index', as:'top50_attribute_dict_top50_dictionary_elems'

  get 'top50_objects/:id/top50_nested_objects', to: 'top50_objects#nested_objects', as:'top50_object_top50_nested_objects'

  post 'top50_objects/:id/top50_nested_objects', to: 'top50_objects#create_nested_object'
  get 'top50_objects/:id/top50_nested_objects/new', to: 'top50_objects#new_nested_object', as:'new_top50_object_top50_nested_object'
  
  get 'top50_machines/:id/add_component', to: 'top50_machines#add_component', as:'add_top50_machine_component'
  post 'top50_machines/:id/add_component', to: 'top50_machines#create_component'
  patch 'top50_machines/:id/add_component', to: 'top50_machines#create_component'
  
  get 'top50_machines/:id/add_any_component', to: 'top50_machines#add_any_component', as:'add_top50_machine_any_component'
  post 'top50_machines/:id/add_any_component', to: 'top50_machines#create_any_component'
  
  get 'top50_objects_tp', to: 'top50_objects#index_type', as: 'top50_object_tp'

  get 'top50_objects_tp/:tid', to: 'top50_objects#objects_of_type', as: 'top50_object_by_tp'
  
  get 'top50_objects/info/:id', to: 'top50_objects#show_info', as:'top50_objects_show_info'

  get 'top50_machines/:id/benchmark_results', to: 'top50_machines#benchmark_results', as:'top50_machine_top50_benchmark_results'

  post 'top50_machines/:id/benchmark_results', to: 'top50_machines#create_benchmark_result'

  get 'top50_machines/:id/benchmark_results/add', to: 'top50_machines#add_benchmark_result', as:'new_top50_machine_top50_benchmark_result'
  get 'top50_organizations/:org_id/suborgs', to: 'top50_organizations#suborg', as:'top50_organization_suborg'

# get "top50_machines" => "top50_machines#index"
# get "top50_machine" => "top50_machines#show"
# get "edit_top50_machine" => "top50_machines#edit"
# get "new_top50_machine" => "top50_machines#new"
# patch "top50_machines" => "top50_machines#update"
# post "top50_machines" => "top50_machines#create"
# get "top50_attributes_dbval" => "top50_attribute_dbval#index"

  namespace :admin do
    mount Sidekiq::Web => "/sidekiq", :constraints => AdminConstraint.new

    resources :users do
      member do
        post :block_access
        post :unblock_access
      end
    end

    resources :groups do
      put :default, on: :collection
    end
  end
end
