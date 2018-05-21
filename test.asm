.data														
space1: .space 4000															
str:   .asciiz "\n\n\n\n"
str0:  .asciiz "                  ========== MINI PROJECT EXERCISE 8 ==========\n"
str1:  .asciiz "\n                                                                     Pham Quoc Anh\n\n"
str2:  .asciiz "      1. Nhap thong tin\n"
str3:  .asciiz "      2. In danh sach\n"
str4:  .asciiz "      3. Sap xep\n"
str5:  .asciiz "      4. Thoat\n"
str6:  .asciiz "      Your choice(1-->4): "
str7:  .asciiz "\n    Nhap so luong sinh vien(<=20): " 
str8:  .asciiz "\nTen: "
str9:  .asciiz "Diem: "
str10: .asciiz "\nSTT   Ten                       Diem\n"
str11: .asciiz "     "
str12: .asciiz "                      "
char:  .asciiz "\n"
error: .asciiz "   Ban nhap sai,hay nhap lai diem cua sinh vien.\n"
mang: .word 0,0,0,0,0,0,0,0
.text
start:
	li $v0,4
	la $a0,str
	syscall
	li $v0,4
	la $a0,str0
	syscall
	li $v0,4
	la $a0,str1
	syscall
menu:
	jal create_menu
get_choice:
	li, $v0,4
	la $a0,str6
	syscall
	li,$v0,5
	syscall
	move $t0,$v0

check1:
	li $t1,1
	bne $t0,$t1,check2
	jal func1
	j menu
check2:
	li $t1,2
	bne $t0,$t1,check3
	jal func2
	j menu
check3:
	li $t1,3
	bne $t0,$t1,check4
	jal func3
	j menu
check4:
	li $t1,4
	beq $t0,$t1,end_program	
wrong:
	j get_choice			# insert again
end_program:
	li $v0,10
	syscall
endstart:

create_menu:			

	li,$v0,4
	la $a0,char
	syscall
	la $a0,str2
	syscall
	la $a0,str3
	syscall
	la $a0,str4
	syscall
	la $a0,str5
	syscall
	jr $ra
endcreate_menu:

func1: 
	li $v0,4
	la $a0,str7 
	syscall
	li $v0,5		#get number of student-n
	syscall 
	blez $v0,func1 			# if n<=0 then input again
	sle $t0,$v0,20  		# 
	beq $t0,$zero,func1		# if n>20 then input again
	move $s0,$v0		# s0 store number of student

	li $t1,0				# count=0
	li $t4,0
	la $a0,space1
get_name:
	li $v0,4
	la $a0,str8
	syscall
	
	la $a0,space1
	mul $t2,$t1,32
	li $v0,8
	add $a0,$a0,$t2 	#address of student i
	li $a1,28
	syscall

########### Remove enter char of string input		
	#get_length: la $a0, string # a0 = Address(string[0])
	xor $v0, $zero, $zero # v0 = length = 0
	xor $t3, $zero, $zero # t0 = i = 0
check_char: add $t7, $a0, $t3 # t1 = a0 + t0
	#= Address(string[0]+i)
	lb $t5, 0($t7) # t2 = string[i]
	beq $t5,$zero,end_of_str # Is null char?
	addi $v0, $v0, 1 # v0=v0+1->length=length+1
	addi $t3, $t3, 1 # t0=t0+1->i = i + 1
j check_char
        
end_of_str:
	addi $t7,$t7,-1
        sb $0,0($t7)
########### Remove enter char of string input	
       
	
	li $v0,4
	la $a0,str9
	syscall
	
get_diem: 
	la $a0,space1
	add $a0,$a0,$t2
	add $a0,$a0,28		#dia chi cua diem
	li $v0,5
	syscall
	bltz $v0,error_mark    #neu diem nhap vao nho hon 0 bao loi
	bgt  $v0,10,error_mark   #bao loi neu diem nhap vao lon hon 10
	sw $v0,0($a0)
	
	add $t1,$t1,1		#tang bien count len 1
	blt $t1,$s0,get_name	#kiem tra xem da nhap du n phan tu
	jr $ra
		
	
	
	
	
	
error_mark:      
   	li $v0,4                                        #error when input mark
	la $a0,error
	syscall
	j get_diem     


	
endfunc1:

func2:

	addi $t3,$zero,0
	addi $t3,$zero,28
	li $t0,0					# i = 0
	la $t1,space1			            #t1 = address of a[0]
	li $a1,1
	li $v0,4
	la $a0,str10
	syscall
print:
	li $v0,1           #print STT
	move $a0,$a1
	syscall
	
	li $v0,4
	la $a0,str11
	syscall

	la $a0,space1
	li $v0,4
	add $a0,$a0,$t0
	syscall	  		#print name
	add $t0,$t0,32
	
	li $v0,4
	la $a0,str12
	syscall
	
	lw $t6,space1($t3)	
	li $v0,1
	addi $a0,$t6,0		#print diem
	syscall
	add $t3,$t3,32
	add $a1,$a1,1		#increase count number to 1 
	
	
	li $v0,4
	la $a0,char
	syscall
	ble $a1,$s0,print	#check if print n student
	
	
	
	jr $ra
	

	
	
endfunc2:

func3:
	li $v1,10 #highest mark
	li $t1,0 #count
	la $t4,mang #address of mang 
	
loop2: 	li $t2,0 #dem vong lap
	la $t5,space1
	add $t5,$t5,28	
	
loop3: # tim index luu vao mang
	lw $t3,0($t5)
	beq $t3,$v1,addindex		#neu tim thay sinh vien co diem =max, luu chi so vao mang
	add $t2,$t2,1
	add $t5,$t5,32
	beq $t2,$s0,endloop2
	j loop3


addindex:
	sw $t2,0($t4)		#luu index vao mang
	add $t4,$t4,4		#tang dia chi cua mang len 4 bye
	add $t2,$t2,1		#tang bien dem
	add $t5,$t5,32		#tang dia chi cua space1
	beq $t2,$s0,endloop2	#kiem tra xem da duyet het
	j loop3

endloop2:
	add $v1,$v1,-1		#max=max-1
	beq $v1,$zero,printlist	#neu max =0 bat dau in danh sach
	j loop2
	
	
printlist:
	li $v1,0 #count
	la $a1,mang
printloop:
	lw $a0,0($a1) #load index of max element
	la $t0,space1
	mul $t3,$a0,32
	add $t0,$t0,$t3 #address of max element
	li $v0,4
	move $a0,$t0     # print name
	syscall

	li $v0,4
	la $a0,str12
	syscall  	#print tab
	
	move $a0,$t0
	add $a0,$a0,28
	li $v0,1
	lw,$a0,0($a0)
	syscall           #print mark
	
	li $v0,4
	la $a0,char
	syscall

	
	add $v1,$v1,1
	add $a1,$a1,4
	blt $v1,$s0,printloop
	jr $ra
		
	

	
endfunc3:
