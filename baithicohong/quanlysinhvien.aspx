<%@ Page Title="Quản lý sinh viên" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="quanlysinhvien.aspx.cs" Inherits="baithicohong.quanlysinhvien" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .page-header-title { font-size: 18px; font-weight: bold; color: #1e293b; margin-bottom: 20px; display: flex; align-items: center; gap: 8px; text-transform: uppercase; }
        
        
        .filter-bar { display: flex; justify-content: space-between; align-items: center; background: #fff; padding: 12px 15px; border-radius: 6px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); margin-bottom: 20px; flex-wrap: wrap; gap: 10px; }
        .filter-left { display: flex; align-items: center; gap: 10px; flex: 1; }
        
        .input-search { padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 4px; font-size: 13px; outline: none; width: 280px; }
        .select-class { padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 4px; font-size: 13px; outline: none; background: white; min-width: 180px; }
        
        .btn-filter { background-color: #3b82f6; color: white; border: none; padding: 8px 16px; border-radius: 4px; font-size: 13px; font-weight: 500; cursor: pointer; display: flex; align-items: center; gap: 5px; }
        .btn-add-new { background-color: #22c55e; color: white; border: none; padding: 8px 16px; border-radius: 4px; font-size: 13px; font-weight: 500; cursor: pointer; display: flex; align-items: center; gap: 5px; text-decoration: none; }

        
        .grid-container { background: white; border-radius: 6px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); overflow: hidden; }
        .main-table { width: 100%; border-collapse: collapse; }
        .main-table th { background-color: #f8fafc; color: #475569; padding: 12px 15px; text-align: left; font-size: 12px; font-weight: 700; border-bottom: 1px solid #e2e8f0; text-transform: uppercase; }
        .main-table td { padding: 12px 15px; border-bottom: 1px solid #f1f5f9; font-size: 13px; color: #334155; vertical-align: middle; }
        
        .student-avatar { width: 38px; height: 38px; border-radius: 50%; object-fit: cover; }
        
        
        .class-badge { background-color: #f1f5f9; color: #334155; padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 500; display: inline-block; border: 1px solid #e2e8f0; }

        
        .btn-action-edit { background-color: #fef3c7; color: #d97706; border: 1px solid #fde68a; padding: 4px 10px; border-radius: 4px; font-size: 12px; text-decoration: none; font-weight: 500; display: inline-flex; align-items: center; gap: 4px; margin-right: 4px; }
        .btn-action-delete { background-color: #fee2e2; color: #dc2626; border: 1px solid #fca5a5; padding: 4px 10px; border-radius: 4px; font-size: 12px; text-decoration: none; font-weight: 500; display: inline-flex; align-items: center; gap: 4px; }

        
        .form-box { background: white; padding: 20px; border-radius: 6px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); margin-bottom: 20px; border: 1px solid #e2e8f0; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        .form-group { display: flex; flex-direction: column; gap: 5px; font-size: 13px; font-weight: 600; }
        
        
        .grid-footer-bar { display: flex; justify-content: space-between; align-items: center; padding: 12px 15px; background: white; font-size: 13px; color: #64748b; border-top: 1px solid #e2e8f0; }
        .pagination-num { display: flex; gap: 4px; }
        .page-btn { padding: 4px 10px; border: 1px solid #cbd5e1; border-radius: 4px; color: #334155; text-decoration: none; font-size: 12px; }
        .page-btn.active { background-color: #3b82f6; color: white; border-color: #3b82f6; }
    </style>

    <div class="page-header-title">
        👥 QUẢN LÝ SINH VIÊN
    </div>

    
    <div class="filter-bar">
        <div class="filter-left">
            <asp:TextBox ID="txtSearch" runat="server" CssClass="input-search" Placeholder="🔍 Tìm theo mã SV, họ tên SV..."></asp:TextBox>
            <asp:DropDownList ID="ddlLopFilter" runat="server" CssClass="select-class" AutoPostBack="true" OnSelectedIndexChanged="ddlLopFilter_SelectedIndexChanged">
            </asp:DropDownList>
            <asp:Button ID="btnLoc" runat="server" Text="🔻 Lọc" CssClass="btn-filter" OnClick="btnLoc_Click" />
        </div>
        <div>
            <asp:Button ID="btnHienFormThem" runat="server" Text="+ Thêm sinh viên" CssClass="btn-add-new" OnClick="btnHienFormThem_Click" />
        </div>
    </div>

    
    <asp:Panel ID="pnlForm" runat="server" CssClass="form-box" Visible="false">
        <h3 style="margin-bottom: 15px; font-size: 15px; color: #1e293b;">
            <asp:Label ID="lblFormTitle" runat="server" Text="Nhập thông tin sinh viên"></asp:Label>
        </h3>
        <div class="form-grid">
            <div class="form-group">
                Mã SV:
                <asp:TextBox ID="txtMaSV" runat="server" CssClass="input-search" Width="100%"></asp:TextBox>
            </div>
            <div class="form-group">
                Họ và tên:
                <asp:TextBox ID="txtHoTen" runat="server" CssClass="input-search" Width="100%"></asp:TextBox>
            </div>
            <div class="form-group">
                Ngày sinh:
                <asp:TextBox ID="txtNgaySinh" runat="server" TextMode="Date" CssClass="input-search" Width="100%"></asp:TextBox>
            </div>
            <div class="form-group">
                Số điện thoại:
                <asp:TextBox ID="txtSDT" runat="server" CssClass="input-search" Width="100%"></asp:TextBox>
            </div>
            <div class="form-group">
                Ảnh đại diện (file):
                <asp:TextBox ID="txtAnh" runat="server" CssClass="input-search" Placeholder="VD: an.jpg" Width="100%"></asp:TextBox>
            </div>
            <div class="form-group">
                Lớp học:
                <asp:DropDownList ID="ddlLopForm" runat="server" CssClass="select-class" Width="100%"></asp:DropDownList>
            </div>
        </div>
        <div style="margin-top: 15px; display: flex; gap: 10px;">
            <asp:Button ID="btnLuu" runat="server" Text="💾 Lưu thông tin" CssClass="btn-filter" OnClick="btnLuu_Click" />
            <asp:Button ID="btnHuy" runat="server" Text="❌ Hủy bỏ" CssClass="btn-filter" Style="background-color: #64748b;" OnClick="btnHuy_Click" />
        </div>
    </asp:Panel>

    
    <div class="grid-container">
        <asp:GridView ID="gvSinhVien" runat="server" AutoGenerateColumns="False" DataKeyNames="MaSV" 
            CssClass="main-table" GridLines="None" OnRowDeleting="gvSinhVien_RowDeleting" OnSelectedIndexChanged="gvSinhVien_SelectedIndexChanged">
            <Columns>
                <asp:BoundField DataField="MaSV" HeaderText="MÃ SV" />
                
                <asp:TemplateField HeaderText="ẢNH">
                    <ItemTemplate>
                        <img src='<%# "Images/" + Eval("Anh") %>' class="student-avatar" alt="Avatar" onerror="this.src='https://via.placeholder.com/38';" />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="HotenSV" HeaderText="HỌ VÀ TÊN" />
                <asp:BoundField DataField="ngaysinh" HeaderText="NGÀY SINH" DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="SDT" HeaderText="SỐ ĐIỆN THOẠI" />
                
                <asp:TemplateField HeaderText="MÃ LỚP">
                    <ItemTemplate>
                        <span class="class-badge"><%# Eval("TenLop") %></span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="THAO TÁC">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnSelect" runat="server" CommandName="Select" CssClass="btn-action-edit">✏️ Sửa</asp:LinkButton>
                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" CssClass="btn-action-delete" OnClientClick="return confirm('Bạn có chắc chắn muốn xóa sinh viên này?');">🗑️ Xóa</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>

        
        <div class="grid-footer-bar">
            <div>
                Tổng số: <strong><asp:Label ID="lblTongSố" runat="server" Text="0"></asp:Label></strong> sinh viên &nbsp;&nbsp;|&nbsp;&nbsp; Trang 1 / 1
            </div>
            <div class="pagination-num">
                <a href="#" class="page-btn active">1</a>
                <a href="#" class="page-btn">2</a>
                <a href="#" class="page-btn">3</a>
                <a href="#" class="page-btn">4</a>
                <a href="#" class="page-btn">Cuối</a>
            </div>
        </div>
    </div>
</asp:Content>