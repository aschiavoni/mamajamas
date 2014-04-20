class ListCopier
  def initialize(source, target)
    @source = source
    @target = target
  end

  def copy
    ActiveRecord::Base.transaction do
      source.list_items.user_items.each do |list_item|
        next if list_item.priority >= 3

        target.list_items.placeholders.
          where(product_type_id: list_item.product_type_id).
          destroy_all
        target.add_list_item ListItem.new(copy_list_item(list_item))
      end
    end
  end

  private

  def source
    @source
  end

  def target
    @target
  end

  def copy_list_item(list_item)
    list_item.attributes.with_indifferent_access.
      except(:id, :list_id, :owned, :rating, :created_at, :updated_at)
  end
end
