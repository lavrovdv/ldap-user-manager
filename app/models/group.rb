# encoding: utf-8
class Group < ActiveLdap::Base
  ldap_mapping :dn_attribute => "cn",
               :prefix => "ou=People",
               :classes => ["organizationalRole"]

  def self.all
    begin
      Group.find(:all)
    rescue
      []
    end
  end
end

