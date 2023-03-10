import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.scss']
})
export class HeaderComponent {
  @Input() title: string = "Mejoramientos Sección Asset Management";
  @Input() logo: string = "assets/LogoBancolombia.png";
  isMenuOpen = false;
  constructor() { }

  onToggleMenu(): void {
    document.querySelector('#menuAnimation')?.classList.toggle('active');
  }
}
