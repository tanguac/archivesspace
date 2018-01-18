class ShelflistReport < AbstractReport

  register_report

  def template
    "shelflist_report.erb"
  end

  def headers
    [
      'repository', 'building', 'floor', 'room', 'area', 'location_barcode',
      'coordinate_label_1', 'coordinate_indicator_1',
      'coordinate_label_2', 'coordinate_indicator_2',
      'coordinate_label_3', 'coordinate_indicator_3',
      'location_profile_name', 'identifier', 'title', 'container_type',
      'container_indicator', 'container_barcode', 'container_profile'
    ]
  end

  def query
    RequestContext.open(:repo_id => repo_id) do
    end
  end

  def each_location
    RequestContext.open(:repo_id => repo_id) do
    end
  end

  def normalize_label(s)
    s.strip
  end

  def to_json
  end

  def to_csv
  end

  def value_for_csv(value)
    if value === true
      'Y'
    elsif value === false
      'N'
    else
      value
    end
  end
end
