require "sidekiq/web"
require "admin_constraint"

Octoshell::Application.routes.draw do
    
  get "certificates/page1" => "certificates#page1"
  post "certificates/page2" => "certificates#page2"
  post "certificates/scr" => "certificates#scr"
    
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

  resources :users do
    get :login_as, on: :member
    get :return_to_self, on: :member
  end
  
  get 'certificates/download', to: 'top50_machines#download_certificate', as: 'download_certificate'

  resource :profile
  get 'top50_machines/application/step1', to: 'top50_machines#app_form_step1', as: 'top50_machines_app_form_step1'
  post 'top50_machines/application/step1', to: 'top50_machines#app_form_step1_presave', as: 'top50_machines_app_form_step1_post'
  get 'top50_machines/application/step2', to: 'top50_machines#app_form_step2', as: 'top50_machines_app_form_step2'
  post 'top50_machines/application/step2', to: 'top50_machines#app_form_step2_presave', as: 'top50_machines_app_form_step2_post'
  get 'top50_machines/application/step3', to: 'top50_machines#app_form_step3', as: 'top50_machines_app_form_step3'
  post 'top50_machines/application/step3', to: 'top50_machines#app_form_step3_presave', as: 'top50_machines_app_form_step3_post'
  get 'top50_machines/application/step4', to: 'top50_machines#app_form_step4', as: 'top50_machines_app_form_step4'
  post 'top50_machines/application/step4', to: 'top50_machines#app_form_step4_presave', as: 'top50_machines_app_form_step4_post'
  get 'top50_machines/application/confirm', to: 'top50_machines#app_form_confirm', as: 'top50_machines_app_form_confirm'
  post 'top50_machines/application/confirm', to: 'top50_machines#app_form_confirm_post', as: 'top50_machines_app_form_confirm_post'
  get 'top50_machines/application/finish', to: 'top50_machines#app_form_finish', as: 'top50_machines_app_form_finish'

  get 'top50_machines/new_list', to: 'top50_machines#new_list', as: 'top50_machines_new_list'
  post 'eop50_machines/new_list', to: 'top50_machines#submit_list', as: 'top50_machines_submit_list'
  get 'top50_machines/delete_list/:id', to: 'top50_machines#destroy_list', as: 'top50_machines_destroy_list'
  get 'top50_machines/edit_list/:id', to: 'top50_machines#new_list', as: 'top50_machines_edit_list'
  post 'top50_machines/edit_list/:id', to: 'top50_machines#submit_list', as: 'top50_machines_save_list'
  get 'top50_machines/add_preview_list/:id', to: 'top50_machines#add_preview_list', as: 'top50_machines_add_preview_list'
  get 'top50_machines/delete_preview_list/:id', to: 'top50_machines#delete_preview_list', as: 'top50_machines_delete_preview_list'
  get 'top50_machines/publish_list/:id', to: 'top50_machines#publish_list', as: 'top50_machines_publish_list'
  get 'top50_machines/unpublish_list/:id', to: 'top50_machines#unpublish_list', as: 'top50_machines_unpublish_list'
  
  get 'top50_machines/moderate/:id', to: 'top50_machines#moderate', as: 'top50_machines_moderate'
  post 'top50_machines/moderate/:id', to: 'top50_machines#pre_save', as: 'top50_machines_presave'
  get 'top50_machines/moderate', to: 'top50_machines#moderate', as: 'top50_machines_moderate_new'
  post 'top50_machines/moderate', to: 'top50_machines#pre_save', as: 'top50_machines_presave_new'

  resources :top50_machines
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
  resources :top50_measure_scales
  resources :top50_benchmarks
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

  resources :newsfeed, only: [:new, :index]
  resources :newsfeed_settings, only: [:new, :create, :index]
  resources :newsfeed_local, only: [:new, :create, :index]

  get '/newsfeed', to: 'newsfeed#index', as: 'newsfeed'
  post '/newsfeed/', to: 'newsfeed#create', as: 'newsfeed_create'
  patch '/newsfeed/', to: 'newsfeed#update', as: 'newsfeed_patch'
  put '/newsfeed/', to: 'newsfeed#update', as: 'newsfeed_put'

  get '/newsfeed_edit_import', to: 'newsfeed_edit_import#index', as: 'newsfeed_edit_import'
  post '/newsfeed_edit_import/', to: 'newsfeed_edit_import#create', as: 'newsfeed_edit_import_create'
  patch '/newsfeed_edit_import/', to: 'newsfeed_edit_import#update', as: 'newsfeed_edit_import_patch'
  put '/newsfeed_edit_import/', to: 'newsfeed_edit_import#update', as: 'newsfeed_edit_import_put'

  patch '/newsfeed_settings/:id', to: 'newsfeed_settings#update', as: 'patch_newsfeed_settings'
  put '/newsfeed_settings/:id', to: 'newsfeed_settings#update', as: 'put_newsfeed_settings'

  delete '/newsfeed_local/:id', to: 'newsfeed_local#destroy', as: 'destroy_newsfeed_local'
  patch '/newsfeed_local/:id', to: 'newsfeed_local#update', as: 'patch_newsfeed_local'
  put '/newsfeed_local/:id', to: 'newsfeed_local#update', as: 'put_newsfeed_local'
  get '/newsfeed_local/:id', to: 'newsfeed_local#show', as: 'show_newsfeed_local'

  resources :newsfeed_edit_local, only: [:index]
  resources :newsfeed_import, only: [:index]
  resources :newsfeed_edit_import, only: [:index]

  patch '/newsfeed_import/:id', to: 'newsfeed_import#update', as: 'patch_newsfeed_import'
  put '/newsfeed_import/:id', to: 'newsfeed_import#update', as: 'put_newsfeed_import'
  # get '/newsfeed_import/:id', to: 'newsfeed_import#show', as: 'show_newsfeed_import'

  root 'newsfeed#index'
  #root :to => redirect('/newsfeed')

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
