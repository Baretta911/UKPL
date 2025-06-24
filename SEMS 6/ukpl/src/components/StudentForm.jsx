import React from 'react'
import { getRandomStudent, getSampleByStatus } from '../data/sampleData'

const StudentForm = ({ studentData, onInputChange, onEvaluate, onReset, onLoadSample }) => {
  const handleLoadSample = (shouldPass) => {
    const sampleData = getSampleByStatus(shouldPass)
    onLoadSample(sampleData)
  }
  return (
    <div className="card">
      <h2>Data Mahasiswa</h2>
      
      <div className="form-group">
        <label htmlFor="nama">Nama Mahasiswa:</label>
        <input
          type="text"
          id="nama"
          name="nama"
          value={studentData.nama}
          onChange={onInputChange}
          placeholder="Masukkan nama mahasiswa"
        />
      </div>

      <div className="form-group">
        <label htmlFor="nim">NIM:</label>
        <input
          type="text"
          id="nim"
          name="nim"
          value={studentData.nim}
          onChange={onInputChange}
          placeholder="Masukkan NIM"
        />
      </div>

      <div className="form-group">
        <label htmlFor="kehadiran">Persentase Kehadiran (%):</label>
        <input
          type="number"
          id="kehadiran"
          name="kehadiran"
          min="0"
          max="100"
          value={studentData.kehadiran}
          onChange={onInputChange}
          placeholder="0-100"
        />
        <small>Minimal 75% untuk lulus</small>
      </div>

      <div className="form-group">
        <label htmlFor="nilaiTugas">Nilai Tugas (0-100):</label>
        <input
          type="number"
          id="nilaiTugas"
          name="nilaiTugas"
          min="0"
          max="100"
          value={studentData.nilaiTugas}
          onChange={onInputChange}
          placeholder="0-100"
        />
        <small>Minimal 70 untuk lulus</small>
      </div>

      <div className="form-group">
        <label htmlFor="nilaiUTS">Nilai UTS (0-100):</label>
        <input
          type="number"
          id="nilaiUTS"
          name="nilaiUTS"
          min="0"
          max="100"
          value={studentData.nilaiUTS}
          onChange={onInputChange}
          placeholder="0-100"
        />
        <small>Minimal 60 untuk lulus</small>
      </div>

      <div className="form-group">
        <label htmlFor="nilaiUAS">Nilai UAS (0-100):</label>
        <input
          type="number"
          id="nilaiUAS"
          name="nilaiUAS"
          min="0"
          max="100"
          value={studentData.nilaiUAS}
          onChange={onInputChange}
          placeholder="0-100"
        />
        <small>Minimal 60 untuk lulus</small>
      </div>

      <div className="form-group">
        <div className="checkbox-group">
          <input
            type="checkbox"
            id="sertifikasi"
            name="sertifikasi"
            checked={studentData.sertifikasi}
            onChange={onInputChange}
          />
          <label htmlFor="sertifikasi">Memiliki Sertifikasi</label>
        </div>
      </div>

      <div className="form-group">
        <div className="checkbox-group">
          <input
            type="checkbox"
            id="kelengkapanAdmin"
            name="kelengkapanAdmin"
            checked={studentData.kelengkapanAdmin}
            onChange={onInputChange}
          />
          <label htmlFor="kelengkapanAdmin">Kelengkapan Administrasi</label>
        </div>
      </div>      <button onClick={onEvaluate} className="btn-primary">
        Evaluasi Status
      </button>
      <button onClick={onReset} className="btn-secondary" style={{marginLeft: '10px'}}>
        Reset
      </button>
      
      <div style={{marginTop: '15px', paddingTop: '15px', borderTop: '1px solid #ddd'}}>
        <p style={{margin: '0 0 10px 0', fontSize: '14px', color: '#666'}}>
          Contoh Data:
        </p>
        <button 
          onClick={() => handleLoadSample(true)} 
          className="btn-success" 
          style={{marginRight: '10px'}}
        >
          Data Lulus
        </button>
        <button 
          onClick={() => handleLoadSample(false)} 
          className="btn-warning"
        >
          Data Tidak Lulus
        </button>
      </div>
    </div>
  )
}

export default StudentForm
