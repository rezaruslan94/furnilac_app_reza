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
    puts "#{start_date}"
    puts "#{end_date}"
    query = "SELECT t_wh.area_id as tttt, total_wh, total_qty_per_area
FROM (
  SELECT area_id, SUM(wh) as total_wh
  FROM twhs
  WHERE PIC_DATE BETWEEN CAST('start_date' AS DATE) AND CAST('end_date' AS DATE)
  GROUP BY area_id
) AS t_wh
JOIN (
  SELECT area_id, SUM(total_qty) AS total_qty_per_area
  FROM (
    SELECT twh_id, twhs.area_id, SUM(qty) as total_qty
    FROM pics JOIN twhs ON twhs.id=twh_id
    WHERE PIC_DATE BETWEEN CAST('start_date' AS DATE) AND CAST('end_date' AS DATE)
    GROUP BY twh_id
  )  AS total_qty_table
  GROUP BY area_id
) AS t_qty ON t_qty.area_id = t_wh.area_id"
    results = Pic.find_by_sql(query)
  end

  def self.data_report_test_wh(start_date, end_date)
    Twh.select('sum(wh) as total_wh, area_id, pic_date').where(pic_date: start_date..end_date).group(:area_id)
  end

  def self.data_report_people(start_date, end_date)
    division_hash = {}
    Pic.joins(:twh).where(twhs: {pic_date: [start_date..end_date]}).each do |pic|
      area_id = pic.twh.area_id
      twh_id = pic.twh_id
      division_id = pic.twh.area.division_id

      # ingat ini data awal division KALAU belum ada, semua angka mestinya 0, dan nanti di tiap looping akan ditambah sesuai divisi
      if division_hash[division_id].blank? # data untuk division_id ini belum ada, bikin dulu
        division = pic.twh.area.division
        division_hash[division_id] = {
          name: division.name,
          pic_name: division.employee_name, # asumsi saya udah bikin delegate
          eh: 0,
          wh: 0,
          p: 0,
          areas: {}
        }
      end

      # ingat ini data awal area KALAU belum ada, semua angka mestinya 0, dan nanti di tiap looping akan ditambah sesuai divisi
      if division_hash[division_id][:areas][area_id].blank? # data untuk area_id ini belum ada, bikin dulu
        area = pic.twh.area
        division_hash[division_id][:areas][area_id] = {
          name: area.name,
          pic_name: area.employee_name, # asumsi saya udah bikin delegate
          eh: 0,
          wh: 0,
          p: 0,
          twhs: {}
        }
      end

      # ingat ini data awal area KALAU belum ada, semua angka mestinya 0, dan nanti di tiap looping akan ditambah sesuai divisi
      if division_hash[division_id][:areas][area_id][:twhs][twh_id].blank? # data untuk area_id ini belum ada, bikin dulu
        twh = pic.twh
        pp "Ini PIC #{twh.class}"
        pp "Ini PIC.TWH #{pic.twh.class}"
        division_hash[division_id][:areas][area_id][:twhs][twh_id] = {
          wh: 0,
          pics: {}
        }
      end

      # di sini kita baru simpan data beneran untuk tiap pic yang sedang di-loop
      # cache data biar mudah aksesnya
      pic_eh = pic.qty * pic.part.norms
      pic_wh = pic.twh.wh
      pic_p  =  (pic.qty * pic.part.norms) / pic.twh.wh * 100.0
      # simpan data ke pics sesuai division dan area
      division_hash[division_id][:areas][area_id][:twhs][twh_id][:pics][pic.id] = {
        name: pic.part.name,
        eh: pic_eh,
        wh: pic_wh,
        p:  pic_p,
      }

      # sekarang kita agregat data ini per area
      # ambil dulu nilai area_eh dan area_wh
      area_eh = division_hash[division_id][:areas][area_id][:eh]
      twh_wh = division_hash[division_id][:areas][area_id][:twhs][twh_id][:wh]
      # cobe cek dulu isinya
      pp "area_eh = #{area_eh.inspect}"
      pp "TWH_wh = #{twh_wh.inspect}"
      pp "division_hash = #{division_hash.inspect}"
      pp "pic_eh = #{pic_eh.inspect}"
      pp "area_eh is a #{area_eh.class}"
      pp "pic_eh is a #{pic_eh.class}"
      pp "pic_eh adalah #{pic_eh.class}"

      area_eh += pic_eh
      twh_wh += pic_wh
      # simpan kembali ke hash
      division_hash[division_id][:areas][area_id][:eh] = area_eh
      division_hash[division_id][:areas][area_id][:twhs][twh_id][:wh] = twh_wh

      # selalu hitung ulang p dari nilai eh dan wh yg baru
      division_hash[division_id][:areas][area_id][:p] +=  area_eh / twh_wh * 100.0

      # sekarang kita agregat data per division
      division_eh = division_hash[division_id][:eh]
      division_wh = division_hash[division_id][:wh]
      division_eh += pic_eh
      division_wh += pic_wh

      division_hash[division_id][:eh] = division_eh
      division_hash[division_id][:wh] = division_wh
      # selalu hitung ulang p dari nilai eh dan wh yg baru
      division_hash[division_id][:p] +=  division_eh / division_wh * 100.0

    end
    pp "latest division_hash before returned to controller = #{division_hash.inspect}"
    division_hash
  end


end


SELECT * FROM
	(SELECT t_wh.area_id, total_wh, total_norm_and_qty_per_area FROM (
  		SELECT area_id, SUM(wh) as total_wh FROM twhs WHERE PIC_DATE BETWEEN CAST('2017-07-17' AS DATE) AND CAST('2017-07-18' AS DATE)
  		GROUP BY area_id
	) AS t_wh
	JOIN
     (SELECT area_id, SUM(total_qty) AS total_norm_and_qty_per_area FROM (
    	SELECT twh_id, c.area_id, sum(e.qty*e.norms) as total_qty from
			areas a inner join employees b ON a.employee_id = b.id INNER JOIN twhs c ON a.id = c.area_id INNER JOIN pics d ON d.twh_id = c.id JOIN (SELECT pics.id as id, norms, qty FROM parts JOIN pics ON parts.id = pics.part_id) e ON e.id = d.id
WHERE c.pic_date between '2017-07-17' and '2017-07-18'
GROUP BY twh_id
  )  AS total_qty_table
  GROUP BY area_id
) AS t_qty ON t_qty.area_id = t_wh.area_id) A INNER JOIN areas b ON A.area_id = b.id INNER JOIN employees c ON b.employee_id = c.id


=======================================================
#Area

SELECT b.name as Area, c.name as PIC, A.total_norm_and_qty_per_area as EH, A.total_wh as WH, A.total_norm_and_qty_per_area/A.total_wh*100 AS P FROM
	(SELECT t_wh.area_id, total_wh, total_norm_and_qty_per_area FROM (
  		SELECT area_id, SUM(wh) as total_wh FROM twhs WHERE PIC_DATE BETWEEN CAST('2017-07-17' AS DATE) AND CAST('2017-07-18' AS DATE)
  		GROUP BY area_id
	) AS t_wh
	JOIN
     (SELECT area_id, SUM(total_qty) AS total_norm_and_qty_per_area FROM (
    	SELECT twh_id, c.area_id, sum(e.qty*e.norms) as total_qty from
			areas a inner join employees b ON a.employee_id = b.id INNER JOIN twhs c ON a.id = c.area_id INNER JOIN pics d ON d.twh_id = c.id JOIN (SELECT pics.id as id, norms, qty FROM parts JOIN pics ON parts.id = pics.part_id) e ON e.id = d.id
WHERE c.pic_date between '2017-07-17' and '2017-07-18'
GROUP BY twh_id
  )  AS total_qty_table
  GROUP BY area_id
) AS t_qty ON t_qty.area_id = t_wh.area_id) A INNER JOIN areas b ON A.area_id = b.id INNER JOIN employees c ON b.employee_id = c.id

#############################################
#division
SELECT d.name as DivisionName, c.name as PIC, SUM(A.total_norm_and_qty_per_area) as EH, SUM(A.total_wh) as WH, SUM(A.total_norm_and_qty_per_area)/SUM(A.total_wh)*100 AS P FROM
	(SELECT t_wh.area_id, total_wh, total_norm_and_qty_per_area FROM (
  		SELECT area_id, SUM(wh) as total_wh FROM twhs WHERE PIC_DATE BETWEEN CAST('2017-07-17' AS DATE) AND CAST('2017-07-18' AS DATE)
  		GROUP BY area_id
	) AS t_wh
	JOIN
     (SELECT area_id, SUM(total_qty) AS total_norm_and_qty_per_area FROM (
    	SELECT twh_id, c.area_id, sum(e.qty*e.norms) as total_qty from
			areas a inner join employees b ON a.employee_id = b.id INNER JOIN twhs c ON a.id = c.area_id INNER JOIN pics d ON d.twh_id = c.id JOIN (SELECT pics.id as id, norms, qty FROM parts JOIN pics ON parts.id = pics.part_id) e ON e.id = d.id
WHERE c.pic_date between '2017-07-17' and '2017-07-18'
GROUP BY twh_id
  )  AS total_qty_table
  GROUP BY area_id
) AS t_qty ON t_qty.area_id = t_wh.area_id) A INNER JOIN areas b ON A.area_id = b.id INNER JOIN  divisions d ON d.id = b.division_id INNER JOIN employees c ON d.employee_id = c.id

========================================================

def self.data_report_test(start_date, end_date)
  query = ["SELECT t_wh.area_id, total_wh, total_qty_per_area
  FROM (
    SELECT area_id, SUM(wh) as total_wh
    FROM twhs
    WHERE PIC_DATE BETWEEN CAST(? AS DATE) AND CAST(? AS DATE)
    GROUP BY area_id
  ) AS t_wh
  JOIN (
    SELECT area_id, SUM(total_qty) AS total_qty_per_area
    FROM (
      SELECT twh_id, twhs.area_id, SUM(qty) as total_qty
      FROM pics JOIN twhs ON twhs.id=twh_id
      WHERE PIC_DATE BETWEEN CAST(? AS DATE) AND CAST(? AS DATE)
      GROUP BY twh_id
    )  AS total_qty_table
    GROUP BY area_id
  ) AS t_qty ON t_qty.area_id = t_wh.area_id", start_date, end_date, start_date, end_date]
  results = Pic.find_by_sql(query)
end
