require 'spec_helper'

describe ApplicationHelper, :type => :helper do

  it "shows a field error" do
    obj = double(:list_item, :errors => { :name => [ "This name is invalid" ] })
    result = helper.field_error(obj, :name)
    expect(result).to match(/<strong class=\"status-msg error\">.*name.*<\/strong>/)
  end

end
