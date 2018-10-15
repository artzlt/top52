# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180924104050) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abilities", force: true do |t|
    t.string   "action"
    t.string   "subject"
    t.integer  "group_id"
    t.boolean  "available",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "abilities", ["group_id"], name: "index_abilities_on_group_id", using: :btree

  create_table "algoalgorithms", force: true do |t|
    t.string   "name"
    t.string   "name_eng"
    t.string   "wiki_link"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "algobenchmarkresults", force: true do |t|
    t.integer  "benchmark_id"
    t.integer  "machine_id"
    t.float    "result"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "launch_id"
    t.integer  "nodegroup_id"
  end

  create_table "algobenchmarkresultswithdup", id: false, force: true do |t|
    t.integer  "id"
    t.integer  "benchmark_id"
    t.integer  "machine_id"
    t.float    "result"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "launch_id"
    t.integer  "nodegroup_id"
  end

  create_table "algobenchmarks", force: true do |t|
    t.string   "name"
    t.string   "name_eng"
    t.integer  "measure_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "algoimplaunches", force: true do |t|
    t.string   "name"
    t.string   "name_eng"
    t.integer  "imp_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "performer"
  end

  create_table "algoimplauncheswithdup", id: false, force: true do |t|
    t.integer  "id"
    t.string   "name"
    t.string   "name_eng"
    t.integer  "imp_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "performer"
  end

  create_table "algoimplementations", force: true do |t|
    t.string   "name"
    t.string   "name_eng"
    t.integer  "algorithm_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "repo_link"
  end

  create_table "algoplatforms", force: true do |t|
    t.string   "name"
    t.string   "name_eng"
    t.string   "website"
    t.integer  "type_id"
    t.integer  "org_id"
    t.integer  "vendor_id"
    t.integer  "contact_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vendor_ids", array: true
  end

  create_table "algorealizations", id: false, force: true do |t|
    t.integer  "id"
    t.string   "name"
    t.string   "name_eng"
    t.integer  "measure_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "algowiki_entities", force: true do |t|
    t.string   "name",       null: false
    t.string   "name_eng"
    t.integer  "type_id",    null: false
    t.string   "wiki_link"
    t.integer  "is_valid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "announcement_recipients", force: true do |t|
    t.integer "user_id"
    t.integer "announcement_id"
  end

  add_index "announcement_recipients", ["announcement_id"], name: "index_announcement_recipients_on_announcement_id", using: :btree
  add_index "announcement_recipients", ["user_id"], name: "index_announcement_recipients_on_user_id", using: :btree

  create_table "announcements", force: true do |t|
    t.string   "title"
    t.string   "reply_to"
    t.text     "body"
    t.string   "attachment"
    t.boolean  "is_special"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attr_dict_bckp_3108", id: false, force: true do |t|
    t.integer  "attr_id"
    t.integer  "obj_id"
    t.integer  "dict_elem_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bckp_attr_dict_0302", id: false, force: true do |t|
    t.integer  "attr_id"
    t.integer  "obj_id"
    t.integer  "dict_elem_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bckp_attr_val_dbvals_20171101", id: false, force: true do |t|
    t.integer  "attr_id"
    t.integer  "obj_id"
    t.binary   "value"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bckp_attr_val_dict_2202", id: false, force: true do |t|
    t.integer  "attr_id"
    t.integer  "obj_id"
    t.integer  "dict_elem_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bckp_attrvaldict_171016", id: false, force: true do |t|
    t.integer  "attr_id"
    t.integer  "obj_id"
    t.integer  "dict_elem_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bckp_bench_res_2016_11_23", id: false, force: true do |t|
    t.integer  "id"
    t.integer  "benchmark_id"
    t.integer  "machine_id"
    t.float    "result"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bckp_dict_elem_2202", id: false, force: true do |t|
    t.integer  "id"
    t.string   "name"
    t.string   "name_eng"
    t.integer  "dict_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bckp_dict_elems", id: false, force: true do |t|
    t.integer  "id"
    t.string   "name"
    t.string   "name_eng"
    t.integer  "dict_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bckp_dict_elems_2017_11_05", id: false, force: true do |t|
    t.integer  "id"
    t.string   "name"
    t.string   "name_eng"
    t.integer  "dict_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bckp_mach_0208", id: false, force: true do |t|
    t.integer  "id"
    t.string   "name"
    t.string   "name_eng"
    t.string   "website"
    t.integer  "type_id"
    t.integer  "org_id"
    t.integer  "vendor_id"
    t.integer  "contact_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vendor_ids", array: true
  end

  create_table "bckp_mach_1302", id: false, force: true do |t|
    t.integer  "id"
    t.string   "name"
    t.string   "name_eng"
    t.string   "website"
    t.integer  "type_id"
    t.integer  "org_id"
    t.integer  "vendor_id"
    t.integer  "contact_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vendor_ids", array: true
  end

  create_table "bckp_mach_2202", id: false, force: true do |t|
    t.integer  "id"
    t.string   "name"
    t.string   "name_eng"
    t.string   "website"
    t.integer  "type_id"
    t.integer  "org_id"
    t.integer  "vendor_id"
    t.integer  "contact_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vendor_ids", array: true
  end

  create_table "bckp_obj_rel", id: false, force: true do |t|
    t.integer  "id"
    t.integer  "prim_obj_id"
    t.integer  "sec_obj_id"
    t.integer  "sec_obj_qty"
    t.integer  "type_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bckp_obj_rel_2", id: false, force: true do |t|
    t.integer  "id"
    t.integer  "prim_obj_id"
    t.integer  "sec_obj_id"
    t.integer  "sec_obj_qty"
    t.integer  "type_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bckp_org", id: false, force: true do |t|
    t.integer  "id"
    t.string   "name"
    t.string   "name_eng"
    t.string   "website"
    t.integer  "city_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bckp_org2", id: false, force: true do |t|
    t.integer  "id"
    t.string   "name"
    t.string   "name_eng"
    t.string   "website"
    t.integer  "city_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bckp_top50_bench_res", id: false, force: true do |t|
    t.integer  "id"
    t.integer  "benchmark_id"
    t.integer  "machine_id"
    t.float    "result"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bckp_top50_machines", id: false, force: true do |t|
    t.integer  "id"
    t.string   "name"
    t.string   "name_eng"
    t.string   "website"
    t.integer  "type_id"
    t.integer  "org_id"
    t.integer  "vendor_id"
    t.integer  "contact_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vendor_ids", array: true
  end

  create_table "bckp_top50_vendors", id: false, force: true do |t|
    t.integer  "id"
    t.string   "name"
    t.string   "name_eng"
    t.string   "website"
    t.integer  "country_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bckp_vendor_0208", id: false, force: true do |t|
    t.integer  "id"
    t.string   "name"
    t.string   "name_eng"
    t.string   "website"
    t.integer  "country_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments_comments", force: true do |t|
    t.text     "text"
    t.integer  "attachable_id",               null: false
    t.string   "attachable_type", limit: nil, null: false
    t.integer  "user_id",                     null: false
    t.integer  "context_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "comments_comments", ["attachable_type", "attachable_id"], name: "index_comments_comments_on_attachable_type_and_attachable_id", using: :btree
  add_index "comments_comments", ["context_id"], name: "index_comments_comments_on_context_id", using: :btree
  add_index "comments_comments", ["user_id"], name: "index_comments_comments_on_user_id", using: :btree

  create_table "comments_context_groups", force: true do |t|
    t.integer  "context_id", null: false
    t.integer  "group_id",   null: false
    t.integer  "type_ab",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments_context_groups", ["context_id"], name: "index_comments_context_groups_on_context_id", using: :btree
  add_index "comments_context_groups", ["group_id"], name: "index_comments_context_groups_on_group_id", using: :btree

  create_table "comments_contexts", force: true do |t|
    t.string   "name",       limit: nil
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "comments_file_attachments", force: true do |t|
    t.string   "file",            limit: nil
    t.text     "description"
    t.integer  "attachable_id",               null: false
    t.string   "attachable_type", limit: nil, null: false
    t.integer  "user_id",                     null: false
    t.integer  "context_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "comments_file_attachments", ["attachable_id", "attachable_type"], name: "attach_index", using: :btree
  add_index "comments_file_attachments", ["context_id"], name: "index_comments_file_attachments_on_context_id", using: :btree
  add_index "comments_file_attachments", ["user_id"], name: "index_comments_file_attachments_on_user_id", using: :btree

  create_table "comments_group_classes", force: true do |t|
    t.string   "class_name", limit: nil
    t.integer  "obj_id"
    t.integer  "group_id"
    t.boolean  "allow",                  null: false
    t.integer  "type_ab",                null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "comments_group_classes", ["group_id"], name: "index_comments_group_classes_on_group_id", using: :btree

  create_table "comments_taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "attachable_id",               null: false
    t.string   "attachable_type", limit: nil, null: false
    t.integer  "user_id"
    t.integer  "context_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "comments_taggings", ["attachable_type", "attachable_id"], name: "index_comments_taggings_on_attachable_type_and_attachable_id", using: :btree
  add_index "comments_taggings", ["context_id"], name: "index_comments_taggings_on_context_id", using: :btree
  add_index "comments_taggings", ["tag_id", "attachable_id", "attachable_type", "context_id"], name: "att_contex_index", unique: true, using: :btree
  add_index "comments_taggings", ["user_id"], name: "index_comments_taggings_on_user_id", using: :btree

  create_table "comments_tags", force: true do |t|
    t.string "name", limit: nil
  end

  create_table "core_access_fields", force: true do |t|
    t.integer "access_id"
    t.integer "quota"
    t.integer "used",          default: 0
    t.integer "quota_kind_id"
  end

  add_index "core_access_fields", ["access_id"], name: "index_core_access_fields_on_access_id", using: :btree

  create_table "core_accesses", force: true do |t|
    t.integer  "project_id",         null: false
    t.integer  "cluster_id",         null: false
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "project_group_name"
  end

  add_index "core_accesses", ["cluster_id"], name: "index_core_accesses_on_cluster_id", using: :btree
  add_index "core_accesses", ["project_id", "cluster_id"], name: "index_core_accesses_on_project_id_and_cluster_id", unique: true, using: :btree
  add_index "core_accesses", ["project_id"], name: "index_core_accesses_on_project_id", using: :btree

  create_table "core_cities", force: true do |t|
    t.integer "country_id"
    t.string  "title_ru"
    t.string  "title_en"
    t.boolean "checked",    default: false
  end

  add_index "core_cities", ["country_id"], name: "index_core_cities_on_country_id", using: :btree
  add_index "core_cities", ["title_ru"], name: "index_core_cities_on_title_ru", using: :btree

  create_table "core_cluster_logs", force: true do |t|
    t.integer  "cluster_id", null: false
    t.text     "message",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  add_index "core_cluster_logs", ["cluster_id"], name: "index_core_cluster_logs_on_cluster_id", using: :btree
  add_index "core_cluster_logs", ["project_id"], name: "index_core_cluster_logs_on_project_id", using: :btree

  create_table "core_cluster_quotas", force: true do |t|
    t.integer "cluster_id",    null: false
    t.integer "value"
    t.integer "quota_kind_id"
  end

  add_index "core_cluster_quotas", ["cluster_id"], name: "index_core_cluster_quotas_on_cluster_id", using: :btree

  create_table "core_clusters", force: true do |t|
    t.string   "name",                              null: false
    t.string   "host",                              null: false
    t.text     "description"
    t.text     "public_key"
    t.text     "private_key"
    t.string   "admin_login"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "available_for_work", default: true
  end

  add_index "core_clusters", ["private_key"], name: "index_core_clusters_on_private_key", unique: true, using: :btree
  add_index "core_clusters", ["public_key"], name: "index_core_clusters_on_public_key", unique: true, using: :btree

  create_table "core_countries", force: true do |t|
    t.string  "title_ru"
    t.string  "title_en"
    t.boolean "checked",  default: false
  end

  create_table "core_credentials", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "state"
    t.string   "name",       null: false
    t.text     "public_key", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "core_credentials", ["user_id"], name: "index_core_credentials_on_user_id", using: :btree

  create_table "core_critical_technologies", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "core_critical_technologies_per_projects", force: true do |t|
    t.integer "critical_technology_id"
    t.integer "project_id"
  end

  add_index "core_critical_technologies_per_projects", ["critical_technology_id"], name: "icrittechs_on_critical_technologies_per_projects", using: :btree
  add_index "core_critical_technologies_per_projects", ["project_id"], name: "iprojects_on_critical_technologies_per_projects", using: :btree

  create_table "core_department_mergers", force: true do |t|
    t.integer  "source_department_id"
    t.integer  "to_organization_id"
    t.integer  "to_department_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "core_direction_of_sciences", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "core_direction_of_sciences_per_projects", force: true do |t|
    t.integer "direction_of_science_id"
    t.integer "project_id"
  end

  add_index "core_direction_of_sciences_per_projects", ["direction_of_science_id"], name: "idos_on_dos_per_projects", using: :btree
  add_index "core_direction_of_sciences_per_projects", ["project_id"], name: "iproject_on_dos_per_projects", using: :btree

  create_table "core_employment_position_names", force: true do |t|
    t.string   "name"
    t.text     "autocomplete"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "core_employment_positions", force: true do |t|
    t.integer  "employment_id"
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "core_employment_positions", ["employment_id"], name: "index_core_employment_positions_on_employment_id", using: :btree

  create_table "core_employments", force: true do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.boolean  "primary"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_department_id"
  end

  add_index "core_employments", ["organization_department_id"], name: "index_core_employments_on_organization_department_id", using: :btree

  create_table "core_members", force: true do |t|
    t.integer  "user_id",                                    null: false
    t.integer  "project_id",                                 null: false
    t.boolean  "owner",                      default: false
    t.string   "login"
    t.string   "project_access_state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id"
    t.integer  "organization_department_id"
  end

  add_index "core_members", ["organization_id"], name: "index_core_members_on_organization_id", using: :btree
  add_index "core_members", ["owner", "user_id", "project_id"], name: "index_core_members_on_owner_and_user_id_and_project_id", using: :btree
  add_index "core_members", ["project_access_state"], name: "index_core_members_on_project_access_state", using: :btree
  add_index "core_members", ["project_id"], name: "index_core_members_on_project_id", using: :btree
  add_index "core_members", ["user_id", "owner"], name: "index_core_members_on_user_id_and_owner", using: :btree
  add_index "core_members", ["user_id", "project_id"], name: "index_core_members_on_user_id_and_project_id", unique: true, using: :btree
  add_index "core_members", ["user_id"], name: "index_core_members_on_user_id", using: :btree

  create_table "core_organization_departments", force: true do |t|
    t.integer "organization_id"
    t.string  "name"
    t.boolean "checked",         default: false
  end

  add_index "core_organization_departments", ["organization_id"], name: "index_core_organization_departments_on_organization_id", using: :btree

  create_table "core_organization_kinds", force: true do |t|
    t.string   "name"
    t.boolean  "departments_required", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "core_organizations", force: true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.integer  "kind_id"
    t.integer  "country_id"
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "checked",      default: false
  end

  add_index "core_organizations", ["city_id"], name: "index_core_organizations_on_city_id", using: :btree
  add_index "core_organizations", ["country_id"], name: "index_core_organizations_on_country_id", using: :btree
  add_index "core_organizations", ["kind_id"], name: "index_core_organizations_on_kind_id", using: :btree

  create_table "core_project_cards", force: true do |t|
    t.integer  "project_id"
    t.text     "name"
    t.text     "en_name"
    t.text     "driver"
    t.text     "en_driver"
    t.text     "strategy"
    t.text     "en_strategy"
    t.text     "objective"
    t.text     "en_objective"
    t.text     "impact"
    t.text     "en_impact"
    t.text     "usage"
    t.text     "en_usage"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "core_project_cards", ["project_id"], name: "index_core_project_cards_on_project_id", using: :btree

  create_table "core_project_invitations", force: true do |t|
    t.integer  "project_id", null: false
    t.string   "user_fio",   null: false
    t.string   "user_email", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "core_project_invitations", ["project_id"], name: "index_core_project_invitations_on_project_id", using: :btree

  create_table "core_project_kinds", force: true do |t|
    t.string "name"
  end

  create_table "core_projects", force: true do |t|
    t.string   "title",                      null: false
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id"
    t.integer  "organization_department_id"
    t.integer  "kind_id"
    t.datetime "first_activation_at"
    t.datetime "finished_at"
    t.datetime "estimated_finish_date"
  end

  add_index "core_projects", ["kind_id"], name: "index_core_projects_on_kind_id", using: :btree
  add_index "core_projects", ["organization_department_id"], name: "index_core_projects_on_organization_department_id", using: :btree
  add_index "core_projects", ["organization_id"], name: "index_core_projects_on_organization_id", using: :btree
  add_index "core_projects", ["state"], name: "index_core_projects_on_state", using: :btree

  create_table "core_quota_kinds", force: true do |t|
    t.string "name"
    t.string "measurement"
  end

  create_table "core_request_fields", force: true do |t|
    t.integer "request_id",    null: false
    t.integer "value"
    t.integer "quota_kind_id"
  end

  add_index "core_request_fields", ["request_id"], name: "index_core_request_fields_on_request_id", using: :btree

  create_table "core_requests", force: true do |t|
    t.integer  "project_id", null: false
    t.integer  "cluster_id", null: false
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cpu_hours"
    t.integer  "gpu_hours"
    t.integer  "hdd_size"
    t.string   "group_name"
    t.integer  "creator_id"
    t.text     "comment"
  end

  add_index "core_requests", ["cluster_id"], name: "index_core_requests_on_cluster_id", using: :btree
  add_index "core_requests", ["creator_id"], name: "index_core_requests_on_creator_id", using: :btree
  add_index "core_requests", ["project_id"], name: "index_core_requests_on_project_id", using: :btree

  create_table "core_research_areas", force: true do |t|
    t.string   "name"
    t.string   "group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "core_research_areas_per_projects", force: true do |t|
    t.integer "research_area_id"
    t.integer "project_id"
  end

  add_index "core_research_areas_per_projects", ["project_id"], name: "iproject_on_ira_per_projects", using: :btree
  add_index "core_research_areas_per_projects", ["research_area_id"], name: "ira_on_ira_per_projects", using: :btree

  create_table "core_sureties", force: true do |t|
    t.integer  "project_id"
    t.string   "state"
    t.string   "comment"
    t.string   "boss_full_name"
    t.string   "boss_position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "document"
    t.integer  "author_id"
  end

  add_index "core_sureties", ["author_id"], name: "index_core_sureties_on_author_id", using: :btree
  add_index "core_sureties", ["project_id"], name: "index_core_sureties_on_project_id", using: :btree

  create_table "core_surety_members", force: true do |t|
    t.integer "user_id"
    t.integer "surety_id"
    t.integer "organization_id"
    t.integer "organization_department_id"
  end

  add_index "core_surety_members", ["organization_id"], name: "index_core_surety_members_on_organization_id", using: :btree
  add_index "core_surety_members", ["surety_id"], name: "index_core_surety_members_on_surety_id", using: :btree
  add_index "core_surety_members", ["user_id"], name: "index_core_surety_members_on_user_id", using: :btree

  create_table "core_surety_scans", force: true do |t|
    t.integer "surety_id"
    t.string  "image"
  end

  add_index "core_surety_scans", ["surety_id"], name: "index_core_surety_scans_on_surety_id", using: :btree

  create_table "cp_bench_res", id: false, force: true do |t|
    t.integer  "id"
    t.integer  "benchmark_id"
    t.integer  "machine_id"
    t.float    "result"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "groups", force: true do |t|
    t.string   "name"
    t.integer  "weight"
    t.boolean  "system"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "newsfeed_imports", force: true do |t|
    t.text     "title"
    t.string   "initial_title"
    t.text     "link"
    t.string   "tags",                             array: true
    t.date     "date_created"
    t.boolean  "is_ignoring",      default: false
    t.boolean  "is_last_imported", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "newsfeed_locals", force: true do |t|
    t.string   "title"
    t.text     "announce"
    t.text     "body"
    t.text     "link"
    t.date     "date_created"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "header_weight"
    t.integer  "footer_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "newsfeed_settings", force: true do |t|
    t.integer  "number_of_imported_news_shown", default: 20
    t.string   "imported_news_source"
    t.integer  "number_of_local_news_shown",    default: 2
    t.string   "cron_schedule",                 default: "hour"
    t.integer  "cron_value",                    default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pack_access_tickets", id: false, force: true do |t|
    t.integer "access_id"
    t.integer "ticket_id"
  end

  add_index "pack_access_tickets", ["access_id"], name: "index_pack_access_tickets_on_access_id", using: :btree
  add_index "pack_access_tickets", ["ticket_id"], name: "index_pack_access_tickets_on_ticket_id", using: :btree

  create_table "pack_accesses", force: true do |t|
    t.integer  "version_id"
    t.integer  "who_id"
    t.string   "who_type",      limit: nil
    t.string   "status",        limit: nil
    t.integer  "created_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "end_lic"
    t.date     "new_end_lic"
    t.integer  "allowed_by_id"
    t.integer  "lock_version",              default: 0, null: false
  end

  add_index "pack_accesses", ["version_id"], name: "index_pack_accesses_on_version_id", using: :btree
  add_index "pack_accesses", ["who_type", "who_id"], name: "index_pack_accesses_on_who_type_and_who_id", using: :btree

  create_table "pack_clustervers", force: true do |t|
    t.integer  "core_cluster_id"
    t.integer  "version_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
  end

  add_index "pack_clustervers", ["core_cluster_id"], name: "index_pack_clustervers_on_core_cluster_id", using: :btree
  add_index "pack_clustervers", ["version_id"], name: "index_pack_clustervers_on_version_id", using: :btree

  create_table "pack_options_categories", force: true do |t|
    t.string   "category",   limit: nil
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "pack_packages", force: true do |t|
    t.string   "name",        limit: nil
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.boolean  "deleted",                 default: false, null: false
  end

  create_table "pack_version_options", force: true do |t|
    t.integer  "version_id"
    t.string   "name",       limit: nil
    t.text     "value"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "pack_version_options", ["version_id"], name: "index_pack_version_options_on_version_id", using: :btree

  create_table "pack_versions", force: true do |t|
    t.string   "name",             limit: nil
    t.text     "description"
    t.integer  "package_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cost"
    t.string   "folder",           limit: nil
    t.date     "end_lic"
    t.string   "state",            limit: nil
    t.integer  "lock_col",                     default: 0,     null: false
    t.boolean  "deleted",                      default: false, null: false
    t.boolean  "service",                      default: false, null: false
    t.boolean  "delete_on_expire",             default: false, null: false
  end

  add_index "pack_versions", ["package_id"], name: "index_pack_versions_on_package_id", using: :btree

  create_table "profiles", force: true do |t|
    t.integer "user_id",                              null: false
    t.string  "first_name"
    t.string  "last_name"
    t.string  "middle_name"
    t.text    "about"
    t.boolean "receive_info_mails",    default: true
    t.boolean "receive_special_mails", default: true
  end

  create_table "sessions_projects_in_sessions", force: true do |t|
    t.integer "session_id"
    t.integer "project_id"
  end

  add_index "sessions_projects_in_sessions", ["project_id"], name: "index_sessions_projects_in_sessions_on_project_id", using: :btree
  add_index "sessions_projects_in_sessions", ["session_id", "project_id"], name: "i_on_project_and_sessions_ids", unique: true, using: :btree
  add_index "sessions_projects_in_sessions", ["session_id"], name: "index_sessions_projects_in_sessions_on_session_id", using: :btree

  create_table "sessions_report_replies", force: true do |t|
    t.integer  "report_id"
    t.integer  "user_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions_report_replies", ["report_id"], name: "index_sessions_report_replies_on_report_id", using: :btree

  create_table "sessions_report_submit_denial_reasons", force: true do |t|
    t.string "name"
  end

  create_table "sessions_reports", force: true do |t|
    t.integer  "session_id"
    t.integer  "project_id"
    t.integer  "author_id"
    t.integer  "expert_id"
    t.string   "state"
    t.string   "materials"
    t.string   "materials_file_name"
    t.string   "materials_content_type"
    t.integer  "materials_file_size"
    t.datetime "materials_updated_at"
    t.integer  "illustration_points"
    t.integer  "summary_points"
    t.integer  "statement_points"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "submit_denial_reason_id"
    t.text     "submit_denial_description"
  end

  add_index "sessions_reports", ["author_id"], name: "index_sessions_reports_on_author_id", using: :btree
  add_index "sessions_reports", ["expert_id"], name: "index_sessions_reports_on_expert_id", using: :btree
  add_index "sessions_reports", ["project_id"], name: "index_sessions_reports_on_project_id", using: :btree
  add_index "sessions_reports", ["session_id"], name: "index_sessions_reports_on_session_id", using: :btree

  create_table "sessions_sessions", force: true do |t|
    t.string   "state"
    t.text     "description"
    t.text     "motivation"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "receiving_to"
  end

  create_table "sessions_stats", force: true do |t|
    t.integer "session_id"
    t.integer "survey_field_id"
    t.string  "group_by",        default: "count"
    t.integer "weight",          default: 0
    t.integer "organization_id"
    t.text    "cache"
  end

  add_index "sessions_stats", ["session_id", "organization_id"], name: "index_sessions_stats_on_session_id_and_organization_id", using: :btree
  add_index "sessions_stats", ["session_id", "survey_field_id"], name: "index_sessions_stats_on_session_id_and_survey_field_id", using: :btree
  add_index "sessions_stats", ["session_id"], name: "index_sessions_stats_on_session_id", using: :btree

  create_table "sessions_survey_fields", force: true do |t|
    t.integer "survey_id"
    t.string  "kind"
    t.text    "collection"
    t.integer "max_values",        default: 1
    t.integer "weight",            default: 0
    t.text    "name"
    t.boolean "required",          default: false
    t.string  "entity"
    t.boolean "strict_collection", default: false
    t.string  "hint"
    t.string  "reference_type"
    t.string  "regexp"
  end

  add_index "sessions_survey_fields", ["survey_id"], name: "index_sessions_survey_fields_on_survey_id", using: :btree

  create_table "sessions_survey_kinds", force: true do |t|
    t.string "name"
  end

  create_table "sessions_survey_values", force: true do |t|
    t.text    "value"
    t.integer "survey_field_id"
    t.integer "user_id"
    t.integer "user_survey_id"
  end

  add_index "sessions_survey_values", ["survey_field_id", "user_survey_id"], name: "isurvey_field_and_user", using: :btree
  add_index "sessions_survey_values", ["user_survey_id"], name: "index_sessions_survey_values_on_user_survey_id", using: :btree

  create_table "sessions_surveys", force: true do |t|
    t.integer "session_id"
    t.integer "kind_id"
    t.string  "name"
    t.boolean "only_for_project_owners"
  end

  add_index "sessions_surveys", ["kind_id"], name: "index_sessions_surveys_on_kind_id", using: :btree
  add_index "sessions_surveys", ["session_id"], name: "index_sessions_surveys_on_session_id", using: :btree

  create_table "sessions_user_surveys", force: true do |t|
    t.integer  "user_id"
    t.integer  "session_id"
    t.integer  "survey_id"
    t.integer  "project_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions_user_surveys", ["project_id"], name: "index_sessions_user_surveys_on_project_id", using: :btree
  add_index "sessions_user_surveys", ["session_id", "survey_id"], name: "index_sessions_user_surveys_on_session_id_and_survey_id", using: :btree
  add_index "sessions_user_surveys", ["session_id"], name: "index_sessions_user_surveys_on_session_id", using: :btree
  add_index "sessions_user_surveys", ["user_id"], name: "index_sessions_user_surveys_on_user_id", using: :btree

  create_table "statistics_organization_stats", force: true do |t|
    t.string   "kind"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statistics_project_stats", force: true do |t|
    t.string   "kind"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statistics_session_stats", force: true do |t|
    t.string   "kind"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statistics_user_stats", force: true do |t|
    t.string   "kind"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "support_field_values", force: true do |t|
    t.integer  "field_id"
    t.integer  "ticket_id"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "support_field_values", ["ticket_id"], name: "index_support_field_values_on_ticket_id", using: :btree

  create_table "support_fields", force: true do |t|
    t.string   "name"
    t.string   "hint"
    t.boolean  "required",             default: false
    t.boolean  "contains_source_code", default: false
    t.boolean  "url",                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "support_replies", force: true do |t|
    t.integer  "author_id"
    t.integer  "ticket_id"
    t.text     "message"
    t.string   "attachment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  add_index "support_replies", ["author_id"], name: "index_support_replies_on_author_id", using: :btree
  add_index "support_replies", ["ticket_id"], name: "index_support_replies_on_ticket_id", using: :btree

  create_table "support_reply_templates", force: true do |t|
    t.string "subject"
    t.text   "message"
  end

  create_table "support_tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "support_tickets", force: true do |t|
    t.integer  "topic_id"
    t.integer  "project_id"
    t.integer  "cluster_id"
    t.integer  "surety_id"
    t.integer  "reporter_id"
    t.string   "subject"
    t.text     "message"
    t.string   "state"
    t.string   "url"
    t.string   "attachment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "responsible_id"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  add_index "support_tickets", ["cluster_id"], name: "index_support_tickets_on_cluster_id", using: :btree
  add_index "support_tickets", ["project_id"], name: "index_support_tickets_on_project_id", using: :btree
  add_index "support_tickets", ["reporter_id"], name: "index_support_tickets_on_reporter_id", using: :btree
  add_index "support_tickets", ["responsible_id"], name: "index_support_tickets_on_responsible_id", using: :btree
  add_index "support_tickets", ["state"], name: "index_support_tickets_on_state", using: :btree
  add_index "support_tickets", ["topic_id"], name: "index_support_tickets_on_topic_id", using: :btree

  create_table "support_tickets_subscribers", force: true do |t|
    t.integer "ticket_id"
    t.integer "user_id"
  end

  add_index "support_tickets_subscribers", ["ticket_id", "user_id"], name: "index_support_tickets_subscribers_on_ticket_id_and_user_id", unique: true, using: :btree
  add_index "support_tickets_subscribers", ["ticket_id"], name: "index_support_tickets_subscribers_on_ticket_id", using: :btree
  add_index "support_tickets_subscribers", ["user_id"], name: "index_support_tickets_subscribers_on_user_id", using: :btree

  create_table "support_tickets_tags", force: true do |t|
    t.integer "ticket_id"
    t.integer "tag_id"
  end

  add_index "support_tickets_tags", ["tag_id"], name: "index_support_tickets_tags_on_tag_id", using: :btree
  add_index "support_tickets_tags", ["ticket_id"], name: "index_support_tickets_tags_on_ticket_id", using: :btree

  create_table "support_topics", force: true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "support_topics_fields", force: true do |t|
    t.integer "topic_id"
    t.integer "field_id"
  end

  create_table "support_topics_tags", force: true do |t|
    t.integer "topic_id"
    t.integer "tag_id"
  end

  create_table "tmp_bckp_attr_val_dict", id: false, force: true do |t|
    t.integer  "attr_id"
    t.integer  "obj_id"
    t.integer  "dict_elem_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tmp_bckp_dict_elems", id: false, force: true do |t|
    t.integer  "id"
    t.string   "name"
    t.string   "name_eng"
    t.integer  "dict_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tmp_cpu_firm", id: false, force: true do |t|
    t.integer "attr_id"
    t.integer "obj_id"
    t.integer "proc"
    t.integer "new_proc_id"
    t.integer "firm"
  end

  create_table "tmp_vendors_bckp", id: false, force: true do |t|
    t.integer  "id"
    t.string   "name"
    t.string   "name_eng"
    t.string   "website"
    t.integer  "country_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "top50_attribute_datatypes", force: true do |t|
    t.string   "db_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "top50_attribute_dbvals", id: false, force: true do |t|
    t.integer  "id"
    t.integer  "datatype_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "top50_attribute_dicts", id: false, force: true do |t|
    t.integer  "id"
    t.integer  "dict_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "top50_attribute_val_dbvals", force: true do |t|
    t.integer  "attr_id"
    t.integer  "obj_id"
    t.binary   "value"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "top50_attribute_val_dicts", force: true do |t|
    t.integer  "attr_id"
    t.integer  "obj_id"
    t.integer  "dict_elem_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "top50_attributes", force: true do |t|
    t.string   "name"
    t.string   "name_eng"
    t.integer  "attr_type"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "top50_benchmark_results", force: true do |t|
    t.integer  "benchmark_id"
    t.integer  "machine_id"
    t.float    "result"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "top50_benchmarks", force: true do |t|
    t.string   "name"
    t.string   "name_eng"
    t.integer  "measure_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "top50_cities", force: true do |t|
    t.string   "name"
    t.string   "name_eng"
    t.integer  "region_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "top50_contacts", id: false, force: true do |t|
    t.integer  "id"
    t.string   "name"
    t.string   "name_eng"
    t.string   "surname"
    t.string   "surname_eng"
    t.string   "patronymic"
    t.string   "patronymic_eng"
    t.string   "phone"
    t.string   "email"
    t.text     "extra_info"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "top50_countries", force: true do |t|
    t.string   "name"
    t.string   "name_eng"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "top50_dictionaries", force: true do |t|
    t.string   "name"
    t.string   "name_eng"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "top50_dictionary_elems", force: true do |t|
    t.string   "name"
    t.string   "name_eng"
    t.integer  "dict_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "top50_machine_types", force: true do |t|
    t.string   "name"
    t.string   "name_eng"
    t.integer  "parent_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "top50_machines", id: false, force: true do |t|
    t.integer  "id"
    t.string   "name"
    t.string   "name_eng"
    t.string   "website"
    t.integer  "type_id"
    t.integer  "org_id"
    t.integer  "vendor_id"
    t.integer  "contact_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vendor_ids",        default: [], array: true
    t.date     "installation_date"
  end

  create_table "top50_machines_backup20180904", id: false, force: true do |t|
    t.integer  "id"
    t.string   "name"
    t.string   "name_eng"
    t.string   "website"
    t.integer  "type_id"
    t.integer  "org_id"
    t.integer  "vendor_id"
    t.integer  "contact_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vendor_ids", array: true
  end

  create_table "top50_measure_units", force: true do |t|
    t.string   "name"
    t.string   "name_eng"
    t.integer  "asc_order"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "top50_object_relations", id: false, force: true do |t|
    t.integer  "prim_obj_id"
    t.integer  "sec_obj_id"
    t.integer  "sec_obj_qty"
    t.integer  "type_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "top50_object_types", force: true do |t|
    t.string   "name"
    t.string   "name_eng"
    t.integer  "parent_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "top50_objects", force: true do |t|
    t.integer  "type_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "top50_organizations", id: false, force: true do |t|
    t.integer  "id"
    t.string   "name"
    t.string   "name_eng"
    t.string   "website"
    t.integer  "city_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "top50_regions", force: true do |t|
    t.string   "name"
    t.string   "name_eng"
    t.integer  "country_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "top50_relation_types", force: true do |t|
    t.string   "name"
    t.string   "name_eng"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "top50_relations", force: true do |t|
    t.integer  "prim_obj_id"
    t.integer  "sec_obj_id"
    t.integer  "sec_obj_qty"
    t.integer  "type_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "top50_valid_types", force: true do |t|
    t.string   "name"
    t.string   "name_eng"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "top50_vendors", id: false, force: true do |t|
    t.integer  "id"
    t.string   "name"
    t.string   "name_eng"
    t.string   "website"
    t.integer  "country_id"
    t.integer  "is_valid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_groups", force: true do |t|
    t.integer "user_id"
    t.integer "group_id"
  end

  add_index "user_groups", ["group_id"], name: "index_user_groups_on_group_id", using: :btree
  add_index "user_groups", ["user_id"], name: "index_user_groups_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                           null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "activation_state"
    t.string   "activation_token"
    t.datetime "activation_token_expires_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "access_state"
    t.datetime "deleted_at"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.string   "last_login_from_ip_address"
  end

  add_index "users", ["activation_token"], name: "index_users_on_activation_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["last_login_at"], name: "index_users_on_last_login_at", using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree

  create_table "vendors_separ", id: false, force: true do |t|
    t.integer "id"
    t.string  "name"
    t.text    "sepname"
    t.integer "sep_vendor_id"
  end

  create_table "wiki_pages", force: true do |t|
    t.string   "name"
    t.text     "content"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wiki_pages", ["url"], name: "index_wiki_pages_on_url", unique: true, using: :btree

end
