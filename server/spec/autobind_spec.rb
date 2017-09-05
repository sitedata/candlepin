require 'spec_helper'
require 'candlepin_scenarios'

describe 'Autobind On Owner' do

  include CandlepinMethods

  it 'succeeds when requesting bind of muliple pools with same stack id' do
  owner_key = random_string('test_owner')
  owner = create_owner owner_key

  # create 4 products with the same stack id and sockets.
  prod = create_product('taylorid', 'taylor swift', {:owner => owner_key, :version => "6.1",
    :attributes => {
      "sockets" => "2",
      "vcpu" => "4",
      "warning_period" => "30",
      "brand_type" => "OS",
      :stacking_id => "ouch"}})
  prod1 = create_product(nil, nil, {:owner => owner_key, :attributes => {
    :stacking_id => "ouch",
    "virt_limit" => 1,
    "sockets" => 1,
    "instance_multiplier" => 2,
    "multi-entitlement" => "yes",
    "host_limited" => "true"}})

  prod2 = create_product(nil, nil, {:owner => owner_key, :attributes => {
    :stacking_id => "ouch",
    "virt_limit" => 1,
    "sockets" => 1,
    "instance_multiplier" => 2,
    "multi-entitlement" => "yes",
    "host_limited" => "true"}})
  prod3 = create_product(nil, nil, {:owner => owner_key, :attributes => {
    :stacking_id => "ouch",
    "virt_limit" => 1,
    "sockets" => 1,
    "instance_multiplier" => 2,
    "multi-entitlement" => "yes",
    "host_limited" => "true"}})

  # create 4 pools, all must provide product "prod" . none of them
  # should provide enough sockets to heal the host on it's own
  create_pool_and_subscription(owner['key'], prod['id'], 10)
  create_pool_and_subscription(owner['key'], prod1['id'], 20, [prod['id']])
  create_pool_and_subscription(owner['key'], prod2['id'], 20, [prod['id']])
  create_pool_and_subscription(owner['key'], prod3['id'], 20, [prod['id']])

  # create a guest with "prod" as an installed product
  guest_uuid =  random_string('guest')
  guest_facts = {
    "virt.is_guest"=>"true",
    "virt.uuid"=>"myGuestId",
    "cpu.cpu_socket(s)"=>"1",
    "virt.host_type"=>"kvm",
    "system.certificate_version"=>"3.2"
  }
  guest = @cp.register('guest.bind.com',:system, guest_uuid, guest_facts, 'admin',
    owner_key, [], [{"productId" => prod.id, "productName" => "taylor swift"}])

  # create a hypervisor that needs 40 sockets and report the guest with it
  hypervisor_facts = {
    "virt.is_guest"=>"false",
    "cpu.cpu(s)"=>"4",
    "cpu.cpu_socket(s)"=>"40"
  }
  hypervisor_guests = [{"guestId"=>"myGuestId"}]
  hypervisor_uuid = random_string("hypervisor")
  hypervisor = @cp.register('hypervisor.bind.com',:system, hypervisor_uuid, hypervisor_facts, 'admin',
    owner_key, [], [], nil, [], random_string('hypervisorid'))
  hypervisor = @cp.update_consumer({:uuid => hypervisor.uuid, :guestIds => hypervisor_guests})

  @cp.list_owner_pools(owner_key).length.should == 7

  @cp.consume_product(nil, {:uuid => guest_uuid})

  @cp.list_owner_pools(owner_key).length.should == 8

  # heal should succeed, and hypervisor should consume 2 pools of 20 sockets each
  @cp.list_entitlements({:uuid => hypervisor_uuid}).length.should == 2
  @cp.list_entitlements({:uuid => guest_uuid}).length.should == 1

  @cp.revoke_all_entitlements(hypervisor_uuid)
  @cp.revoke_all_entitlements(guest_uuid)

  # change the hypervisor to 50 sockets
  hypervisor_facts = {
    "virt.is_guest"=>"false",
    "cpu.cpu(s)"=>"4",
    "cpu.cpu_socket(s)"=>"50"
  }

  # heal should succeed, and hypervisor should consume 3 pools of 20 sockets each
  @cp.update_consumer({:uuid => hypervisor_uuid, :facts => hypervisor_facts})

  @cp.consume_product(nil, {:uuid => guest_uuid})
  @cp.list_entitlements({:uuid => hypervisor_uuid}).length.should == 3
  @cp.list_entitlements({:uuid => guest_uuid}).length.should == 1
  @cp.list_owner_pools(owner_key).length.should == 8

  end

end