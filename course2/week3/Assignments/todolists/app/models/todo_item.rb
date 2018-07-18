class TodoItem < ActiveRecord::Base
    def self.total_items
        self.where(completed: true).count
    end
end
