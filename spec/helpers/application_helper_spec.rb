require 'spec_helper'

describe ApplicationHelper do

  it "shows a field error" do
    obj = stub(:list_item, :errors => { :name => [ "This name is invalid" ] })
    result = helper.field_error(obj, :name)
    result.should =~ /<strong class=\"status-msg error\">.*name.*<\/strong>/
  end

end
