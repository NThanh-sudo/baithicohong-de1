using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace baithicohong
{
    public partial class quanlysinhvien : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["QuanlySVConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDataLop();
                LoadDataSinhVien();
            }
        }

        private void LoadDataLop()
        {
            using (SqlConnection con = new SqlConnection(strCon))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Lop", con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlLopFilter.DataSource = dt;
                ddlLopFilter.DataTextField = "TenLop";
                ddlLopFilter.DataValueField = "MaLop";
                ddlLopFilter.DataBind();
                ddlLopFilter.Items.Insert(0, new ListItem("-- Tất cả lớp học --", ""));

                ddlLopForm.DataSource = dt;
                ddlLopForm.DataTextField = "TenLop";
                ddlLopForm.DataValueField = "MaLop";
                ddlLopForm.DataBind();
            }
        }

        private void LoadDataSinhVien()
        {
            using (SqlConnection con = new SqlConnection(strCon))
            {
                string sql = "SELECT Sinhvien.*, Lop.TenLop FROM Sinhvien JOIN Lop ON Sinhvien.MaLop = Lop.MaLop WHERE 1=1";

                if (!string.IsNullOrEmpty(ddlLopFilter.SelectedValue))
                {
                    sql += " AND Sinhvien.MaLop = @MaLop";
                }
                if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
                {
                    sql += " AND (Sinhvien.HotenSV LIKE @Search OR Sinhvien.MaSV LIKE @Search)";
                }

                SqlCommand cmd = new SqlCommand(sql, con);
                if (!string.IsNullOrEmpty(ddlLopFilter.SelectedValue))
                {
                    cmd.Parameters.AddWithValue("@MaLop", ddlLopFilter.SelectedValue);
                }
                if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
                {
                    cmd.Parameters.AddWithValue("@Search", "%" + txtSearch.Text.Trim() + "%");
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvSinhVien.DataSource = dt;
                gvSinhVien.DataBind();

                
                lblTongSố.Text = dt.Rows.Count.ToString();
            }
        }

        protected void ddlLopFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDataSinhVien();
        }

        protected void btnLoc_Click(object sender, EventArgs e)
        {
            LoadDataSinhVien();
        }

        protected void btnHienFormThem_Click(object sender, EventArgs e)
        {
            pnlForm.Visible = true;
            lblFormTitle.Text = "➕ THÊM SINH VIÊN MỚI";
            txtMaSV.Enabled = true;
            ClearForm();
        }

        protected void btnLuu_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(strCon))
            {
                string sql;
                if (txtMaSV.Enabled)
                {
                    sql = "INSERT INTO Sinhvien (MaSV, HotenSV, ngaysinh, SDT, Anh, MaLop) VALUES (@MaSV, @HotenSV, @ngaysinh, @SDT, @Anh, @MaLop)";
                }
                else
                {
                    sql = "UPDATE Sinhvien SET HotenSV=@HotenSV, ngaysinh=@ngaysinh, SDT=@SDT, Anh=@Anh, MaLop=@MaLop WHERE MaSV=@MaSV";
                }

                SqlCommand cmd = new SqlCommand(sql, con);
                cmd.Parameters.AddWithValue("@MaSV", txtMaSV.Text.Trim());
                cmd.Parameters.AddWithValue("@HotenSV", txtHoTen.Text.Trim());
                cmd.Parameters.AddWithValue("@ngaysinh", DateTime.Parse(txtNgaySinh.Text));
                cmd.Parameters.AddWithValue("@SDT", txtSDT.Text.Trim());
                cmd.Parameters.AddWithValue("@Anh", txtAnh.Text.Trim());
                cmd.Parameters.AddWithValue("@MaLop", ddlLopForm.SelectedValue);

                con.Open();
                cmd.ExecuteNonQuery();
            }
            pnlForm.Visible = false;
            LoadDataSinhVien();
            ClearForm();
        }

        protected void btnHuy_Click(object sender, EventArgs e)
        {
            pnlForm.Visible = false;
            ClearForm();
        }

        protected void gvSinhVien_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnlForm.Visible = true;
            lblFormTitle.Text = "✏️ CẬP NHẬT THÔNG TIN SINH VIÊN";

            GridViewRow row = gvSinhVien.SelectedRow;
            string maSV = gvSinhVien.DataKeys[row.RowIndex].Value.ToString();

            using (SqlConnection con = new SqlConnection(strCon))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM Sinhvien WHERE MaSV = @MaSV", con);
                cmd.Parameters.AddWithValue("@MaSV", maSV);
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    txtMaSV.Text = dr["MaSV"].ToString();
                    txtMaSV.Enabled = false;
                    txtHoTen.Text = dr["HotenSV"].ToString();
                    if (dr["ngaysinh"] != DBNull.Value)
                    {
                        txtNgaySinh.Text = Convert.ToDateTime(dr["ngaysinh"]).ToString("yyyy-MM-dd");
                    }
                    txtSDT.Text = dr["SDT"].ToString();
                    txtAnh.Text = dr["Anh"].ToString();
                    ddlLopForm.SelectedValue = dr["MaLop"].ToString();
                }
            }
        }

        protected void gvSinhVien_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            string maSV = gvSinhVien.DataKeys[e.RowIndex].Value.ToString();
            using (SqlConnection con = new SqlConnection(strCon))
            {
                string sql = "DELETE FROM Sinhvien WHERE MaSV = @MaSV";
                SqlCommand cmd = new SqlCommand(sql, con);
                cmd.Parameters.AddWithValue("@MaSV", maSV);

                con.Open();
                cmd.ExecuteNonQuery();
            }
            LoadDataSinhVien();
        }

        private void ClearForm()
        {
            txtMaSV.Text = "";
            txtHoTen.Text = "";
            txtNgaySinh.Text = "";
            txtSDT.Text = "";
            txtAnh.Text = "";
        }
    }
}