class Pic < ApplicationRecord
  belongs_to :part
  belongs_to :twh
  # validates :wh, :qty, :part_id, :area_id, presence: true
  # validates :qty, :wh, :numericality => {:greater_than => 0, :less_than => 9999999}

  validates :qty, :part_id, presence: true, length: { maximum: 30 }, if: :can_validate?

  def can_validate?
    true
  end

  def self.data_report_person(start_date, end_date, area_combo)
    Pic.joins(:twh).select('sum(qty) as total_qty, part_id, twh_id, wh, area_id, pic_date').where(twhs: {pic_date: [start_date..end_date], area_id: [area_combo]}).group(:part_id)
  end
  def self.data_report_person_wh(start_date, end_date, area_combo)
    Twh.select('wh, area_id, pic_date').where(pic_date: start_date..end_date).where(area_id: area_combo).group(:id)
  end

  def self.data_report_test(start_date, end_date)
    query = [" SELECT b.name as area, c.name as pic, A.total_norm_and_qty_per_area as eh, A.total_wh as wh, A.total_norm_and_qty_per_area/A.total_wh*100 AS nilai_p FROM
    	(SELECT t_wh.area_id, total_wh, total_norm_and_qty_per_area FROM (
      		SELECT area_id, SUM(wh) as total_wh FROM twhs WHERE PIC_DATE BETWEEN CAST(? AS DATE) AND CAST(? AS DATE)
      		GROUP BY area_id
    	) AS t_wh
    	JOIN
         (SELECT area_id, SUM(total_qty) AS total_norm_and_qty_per_area FROM (
        	SELECT twh_id, c.area_id, sum(e.qty*e.norms) as total_qty from
    			areas a inner join employees b ON a.employee_id = b.id INNER JOIN twhs c ON a.id = c.area_id INNER JOIN pics d ON d.twh_id = c.id JOIN (SELECT pics.id as id, norms, qty FROM parts JOIN pics ON parts.id = pics.part_id) e ON e.id = d.id
    WHERE c.PIC_DATE BETWEEN CAST(? AS DATE) AND CAST(? AS DATE)
    GROUP BY twh_id
      )  AS total_qty_table
      GROUP BY area_id
    ) AS t_qty ON t_qty.area_id = t_wh.area_id) A INNER JOIN areas b ON A.area_id = b.id INNER JOIN employees c ON b.employee_id = c.id", start_date, end_date, start_date, end_date]
    results = Pic.find_by_sql(query)
  end

  def self.data_report_test_wh(start_date, end_date)
    Twh.select('sum(wh) as total_wh, area_id, pic_date').where(pic_date: start_date..end_date).group(:area_id)
  end

  def self.data_report_people_area(start_date, end_date)
    query = [" SELECT b.name as area, c.name as pic, A.total_norm_and_qty_per_area as eh, A.total_wh as wh, A.total_norm_and_qty_per_area/A.total_wh*100 AS nilai_p FROM
      (SELECT t_wh.area_id, total_wh, total_norm_and_qty_per_area FROM (
          SELECT area_id, SUM(wh) as total_wh FROM twhs WHERE PIC_DATE BETWEEN CAST(? AS DATE) AND CAST(? AS DATE)
          GROUP BY area_id
      ) AS t_wh
      JOIN
         (SELECT area_id, SUM(total_qty) AS total_norm_and_qty_per_area FROM (
          SELECT twh_id, c.area_id, sum(e.qty*e.norms) as total_qty from
          areas a inner join employees b ON a.employee_id = b.id INNER JOIN twhs c ON a.id = c.area_id INNER JOIN pics d ON d.twh_id = c.id JOIN (SELECT pics.id as id, norms, qty FROM parts JOIN pics ON parts.id = pics.part_id) e ON e.id = d.id
    WHERE c.PIC_DATE BETWEEN CAST(? AS DATE) AND CAST(? AS DATE)
    GROUP BY twh_id
      )  AS total_qty_table
      GROUP BY area_id
    ) AS t_qty ON t_qty.area_id = t_wh.area_id) A INNER JOIN areas b ON A.area_id = b.id INNER JOIN employees c ON b.employee_id = c.id", start_date, end_date, start_date, end_date]
    results = Pic.find_by_sql(query)
  end

  def self.data_report_people_division(start_date, end_date)
    query = [" SELECT d.name as division_name, c.name as pic, SUM(A.total_norm_and_qty_per_area) as eh, SUM(A.total_wh) as wh, SUM(A.total_norm_and_qty_per_area)/SUM(A.total_wh)*100 AS nilai_p
      FROM(
        SELECT t_wh.area_id, total_wh, total_norm_and_qty_per_area
        FROM(
          SELECT area_id, SUM(wh) as total_wh FROM twhs WHERE PIC_DATE BETWEEN CAST(? AS DATE) AND CAST(? AS DATE)
          GROUP BY area_id
        ) AS t_wh
      JOIN(
        SELECT area_id, SUM(total_qty) AS total_norm_and_qty_per_area
        FROM(
          SELECT twh_id, c.area_id, sum(e.qty*e.norms) as total_qty
          FROM areas a inner join employees b ON a.employee_id = b.id INNER JOIN twhs c ON a.id = c.area_id INNER JOIN pics d ON d.twh_id = c.id JOIN (SELECT pics.id as id, norms, qty FROM parts JOIN pics ON parts.id = pics.part_id) e ON e.id = d.id
          WHERE c.PIC_DATE BETWEEN CAST(? AS DATE) AND CAST(? AS DATE)
          GROUP BY twh_id
        ) AS total_qty_table
        GROUP BY area_id
      ) AS t_qty ON t_qty.area_id = t_wh.area_id
      ) A INNER JOIN areas b ON A.area_id = b.id INNER JOIN  divisions d ON d.id = b.division_id INNER JOIN employees c ON d.employee_id = c.id
      GROUP BY b.division_id", start_date, end_date, start_date, end_date]
    results = Pic.find_by_sql(query)
  end

  def self.data_report_people_area_test(start_date, end_date)
    query = [" SELECT b.name as area, c.name as pic, A.total_norm_and_qty_per_area as eh, A.total_wh as wh, A.total_norm_and_qty_per_area/A.total_wh*100 AS nilai_p FROM
      (SELECT t_wh.area_id, total_wh, total_norm_and_qty_per_area FROM (
          SELECT area_id, SUM(wh) as total_wh FROM twhs WHERE PIC_DATE BETWEEN CAST(? AS DATE) AND CAST(? AS DATE)
          GROUP BY area_id
      ) AS t_wh
      JOIN
         (SELECT area_id, SUM(total_qty) AS total_norm_and_qty_per_area FROM (
          SELECT twh_id, c.area_id, sum(e.qty*e.norms) as total_qty from
          areas a inner join employees b ON a.employee_id = b.id INNER JOIN twhs c ON a.id = c.area_id INNER JOIN pics d ON d.twh_id = c.id JOIN (SELECT pics.id as id, norms, qty FROM parts JOIN pics ON parts.id = pics.part_id) e ON e.id = d.id
    WHERE c.PIC_DATE BETWEEN CAST(? AS DATE) AND CAST(? AS DATE)
    GROUP BY twh_id
      )  AS total_qty_table
      GROUP BY area_id
    ) AS t_qty ON t_qty.area_id = t_wh.area_id) A INNER JOIN areas b ON A.area_id = b.id INNER JOIN employees c ON b.employee_id = c.id", start_date, end_date, start_date, end_date]
    results = Pic.find_by_sql(query)
  end


end
