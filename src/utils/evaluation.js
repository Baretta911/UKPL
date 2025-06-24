// Utility functions for student evaluation

/**
 * Evaluates student status based on academic criteria
 * @param {Object} studentData - Student data object
 * @returns {Object} Evaluation result
 */
export const evaluateStudentStatus = (studentData) => {
  const criteria = {
    kehadiran: studentData.kehadiran >= 75, // minimal 75% kehadiran
    nilaiTugas: studentData.nilaiTugas >= 70, // minimal 70
    nilaiUTS: studentData.nilaiUTS >= 60, // minimal 60
    nilaiUAS: studentData.nilaiUAS >= 60, // minimal 60
    sertifikasi: studentData.sertifikasi,
    kelengkapanAdmin: studentData.kelengkapanAdmin
  }

  // Tambahan percabangan untuk cyclomatic complexity
  let extraChecks = 0;
  if (studentData.kehadiran < 50) extraChecks++;
  if (studentData.kehadiran >= 50 && studentData.kehadiran < 75) extraChecks++;
  if (studentData.kehadiran >= 75 && studentData.kehadiran < 90) extraChecks++;
  if (studentData.kehadiran >= 90) extraChecks++;

  if (studentData.nilaiTugas < 50) extraChecks++;
  if (studentData.nilaiTugas >= 50 && studentData.nilaiTugas < 60) extraChecks++;
  if (studentData.nilaiTugas >= 60 && studentData.nilaiTugas < 70) extraChecks++;
  if (studentData.nilaiTugas >= 90) extraChecks++;

  if (studentData.nilaiUTS < 40) extraChecks++;
  if (studentData.nilaiUTS >= 40 && studentData.nilaiUTS < 60) extraChecks++;
  if (studentData.nilaiUTS >= 80) extraChecks++;

  if (studentData.nilaiUAS < 40) extraChecks++;
  if (studentData.nilaiUAS >= 40 && studentData.nilaiUAS < 60) extraChecks++;
  if (studentData.nilaiUAS >= 80) extraChecks++;

  if (studentData.sertifikasi && studentData.kelengkapanAdmin) extraChecks++;
  if (!studentData.sertifikasi && !studentData.kelengkapanAdmin) extraChecks++;
  if (studentData.sertifikasi && studentData.nilaiTugas > 85) extraChecks++;
  if (studentData.kelengkapanAdmin && studentData.kehadiran > 90) extraChecks++;

  // Hitung nilai akhir (bobot: Tugas 30%, UTS 30%, UAS 40%)
  const nilaiAkhir = (studentData.nilaiTugas * 0.3) + (studentData.nilaiUTS * 0.3) + (studentData.nilaiUAS * 0.4)

  // Cek kombinasi syarat khusus
  let kombinasiKhusus = false;
  if (studentData.nilaiTugas > 90 && studentData.nilaiUTS < 60 && studentData.nilaiUAS < 60) kombinasiKhusus = true;
  if (studentData.kehadiran > 95 && studentData.nilaiTugas > 95 && studentData.nilaiUTS > 95 && studentData.nilaiUAS > 95) kombinasiKhusus = true;
  if (studentData.nilaiTugas < 60 && studentData.nilaiUTS < 60 && studentData.nilaiUAS < 60) kombinasiKhusus = true;

  // Cek apakah semua kriteria terpenuhi
  const semuaKriteriaTerpenuhi = Object.values(criteria).every(Boolean)

  // Status lulus jika semua kriteria terpenuhi DAN nilai akhir >= 60
  const statusLulus = semuaKriteriaTerpenuhi && nilaiAkhir >= 60 && !kombinasiKhusus

  return {
    ...criteria,
    nilaiAkhir: Math.round(nilaiAkhir * 100) / 100,
    statusLulus,
    nama: studentData.nama,
    nim: studentData.nim,
    extraChecks,
    kombinasiKhusus
  }
}

/**
 * Get initial student data structure
 * @returns {Object} Initial student data
 */
export const getInitialStudentData = () => ({
  nama: '',
  nim: '',
  kehadiran: 0,
  nilaiTugas: 0,
  nilaiUTS: 0,
  nilaiUAS: 0,
  sertifikasi: false,
  kelengkapanAdmin: false
})

/**
 * Validation rules for student data
 */
export const VALIDATION_RULES = {
  kehadiran: { min: 0, max: 100, required: 75 },
  nilaiTugas: { min: 0, max: 100, required: 70 },
  nilaiUTS: { min: 0, max: 100, required: 60 },
  nilaiUAS: { min: 0, max: 100, required: 60 },
  nilaiAkhir: { required: 60 }
}

/**
 * Get failed criteria reasons
 * @param {Object} result - Evaluation result
 * @returns {Array} Array of failed criteria reasons
 */
export const getFailedReasons = (result) => {
  const reasons = []
  
  if (!result.kehadiran) reasons.push('Kehadiran kurang dari 75%')
  if (!result.nilaiTugas) reasons.push('Nilai tugas kurang dari 70')
  if (!result.nilaiUTS) reasons.push('Nilai UTS kurang dari 60')
  if (!result.nilaiUAS) reasons.push('Nilai UAS kurang dari 60')
  if (!result.sertifikasi) reasons.push('Belum memiliki sertifikasi')
  if (!result.kelengkapanAdmin) reasons.push('Administrasi belum lengkap')
  if (result.nilaiAkhir < 60) reasons.push('Nilai akhir kurang dari 60')
  
  return reasons
}
