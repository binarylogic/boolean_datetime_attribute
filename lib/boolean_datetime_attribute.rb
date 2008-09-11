module BinaryLogic
  module BooleanDatetimeAttribute
    def self.included(base)
      base.extend(ClassMethods)
    end
  
    module ClassMethods
      def boolean_datetime_attribute(*datetime_fields)
        datetime_fields.each do |field|
          boolean_field = field.to_s.gsub(/_at$/, "")
          class_eval <<-"end_eval", __FILE__, __LINE__
            def #{boolean_field}=(value)
              if (value == true || value == 'true' || value == 1 || value == '1')
                self.#{field} = Time.now if !#{boolean_field}?
              else
                self.#{field} = nil if #{boolean_field}?
              end
              #{field}
            end
        
            def #{boolean_field}?
              !#{field}.blank? && #{field} <= Time.current
            end
            alias_method :#{boolean_field}, :#{boolean_field}?
          
            def #{boolean_field}!
              update_attribute :#{field}, Time.now
            end
          end_eval
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, BinaryLogic::BooleanDatetimeAttribute)