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
